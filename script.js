(function () {
  "use strict";

  var contentCache = new Map();

  function byId(id) {
    return document.getElementById(id);
  }

  function isArray(value) {
    return Array.isArray(value);
  }

  function setActiveHeaderLink() {
    var page = document.body ? document.body.dataset.page : "";
    if (!page && window.location.pathname.endsWith("/view.html")) {
      var viewerType = new URLSearchParams(window.location.search).get("type");
      page = viewerType === "skill" ? "skills" : viewerType === "connector" ? "connectors" : "";
    }
    var links = document.querySelectorAll(".nav-link[data-nav]");
    links.forEach(function (link) {
      link.classList.toggle("is-active", link.dataset.nav === page);
    });
  }

  function setCurrentYear() {
    var yearNodes = document.querySelectorAll("[data-year]");
    var year = String(new Date().getFullYear());
    yearNodes.forEach(function (node) {
      node.textContent = year;
    });
  }

  function setCopyButtonState(button, label, ms) {
    if (!button) {
      return;
    }
    var original = button.dataset.defaultLabel || button.textContent;
    button.dataset.defaultLabel = original;
    button.textContent = label;
    button.disabled = true;
    window.setTimeout(function () {
      button.textContent = original;
      button.disabled = false;
    }, ms || 1500);
  }

  async function copyText(text, button) {
    try {
      await navigator.clipboard.writeText(text);
      setCopyButtonState(button, "Copied!", 1500);
    } catch (error) {
      setCopyButtonState(button, "Copy failed", 1600);
    }
  }

  async function loadTextContent(path) {
    if (!path) {
      return "";
    }
    if (contentCache.has(path)) {
      return contentCache.get(path);
    }

    var response = await fetch(path);
    if (!response.ok) {
      throw new Error("Unable to load content: " + path);
    }

    var text = await response.text();
    contentCache.set(path, text);
    return text;
  }

  function renderMarkdown(markdownText) {
    var source = markdownText || "";
    if (source.startsWith("---")) {
      source = source.replace(/^---\s*\n[\s\S]*?\n---\s*\n/, "");
    }
    if (window.marked && typeof window.marked.parse === "function") {
      return window.marked.parse(source);
    }
    return "";
  }

  function addRevealAnimations() {
    var revealNodes = document.querySelectorAll(".reveal");
    if (!revealNodes.length || typeof IntersectionObserver === "undefined") {
      revealNodes.forEach(function (node) {
        node.classList.add("is-visible");
      });
      return;
    }

    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.18 }
    );

    revealNodes.forEach(function (node) {
      observer.observe(node);
    });
  }

  function initPromptsPage() {
    var nav = byId("prompt-quick-nav");
    var container = byId("prompt-sections");
    var sections = window.PROMPT_SECTIONS;

    if (!nav || !container || !isArray(sections)) {
      return;
    }

    var pills = [];
    var sectionNodes = [];

    sections.forEach(function (section, sectionIndex) {
      var pill = document.createElement("button");
      pill.className = "quick-nav-pill";
      pill.type = "button";
      pill.textContent = section.title;
      pill.dataset.target = section.id;
      pill.addEventListener("click", function () {
        var target = byId(section.id);
        if (target) {
          target.scrollIntoView({ behavior: "smooth", block: "start" });
        }
      });
      nav.appendChild(pill);
      pills.push(pill);

      var sectionCard = document.createElement("section");
      sectionCard.className = "prompt-section card reveal";
      sectionCard.id = section.id;

      var title = document.createElement("h2");
      title.textContent = section.title;

      var description = document.createElement("p");
      description.textContent = section.description;

      var list = document.createElement("div");
      list.className = "prompt-list";

      (section.prompts || []).forEach(function (prompt) {
        var promptCard = document.createElement("article");
        promptCard.className = "prompt-card";

        var promptText = prompt.text || "";

        var head = document.createElement("div");
        head.className = "prompt-card-head";

        var promptTitle = document.createElement("h3");
        promptTitle.textContent = prompt.title;

        var copyButton = document.createElement("button");
        copyButton.type = "button";
        copyButton.className = "copy-btn";
        copyButton.textContent = prompt.contentPath ? "Loading" : "Copy";
        copyButton.dataset.defaultLabel = "Copy";
        copyButton.disabled = prompt.contentPath ? true : !promptText;
        copyButton.addEventListener("click", function () {
          if (promptText) {
            copyText(promptText, copyButton);
          }
        });

        head.appendChild(promptTitle);
        head.appendChild(copyButton);

        var panel = document.createElement("div");
        panel.className = "code-panel";

        var pre = document.createElement("pre");
        var markdown = document.createElement("article");
        markdown.className = "markdown-body";

        function renderPromptContent(text) {
          var rendered = renderMarkdown(text);
          if (rendered) {
            markdown.innerHTML = rendered;
            if (pre.parentNode === panel) {
              panel.removeChild(pre);
            }
            if (markdown.parentNode !== panel) {
              panel.appendChild(markdown);
            }
          } else {
            pre.textContent = text;
            if (markdown.parentNode === panel) {
              panel.removeChild(markdown);
            }
            if (pre.parentNode !== panel) {
              panel.appendChild(pre);
            }
          }
        }

        if (prompt.contentPath) {
          pre.textContent = "Loading prompt...";
          panel.appendChild(pre);

          loadTextContent(prompt.contentPath)
            .then(function (text) {
              promptText = text;
              renderPromptContent(text);
              copyButton.textContent = "Copy";
              copyButton.disabled = false;
            })
            .catch(function () {
              renderPromptContent(promptText || "Prompt content could not be loaded.");
              copyButton.textContent = promptText ? "Copy" : "Unavailable";
              copyButton.disabled = !promptText;
            });
        } else {
          renderPromptContent(promptText);
        }

        promptCard.appendChild(head);
        promptCard.appendChild(panel);
        list.appendChild(promptCard);
      });

      sectionCard.appendChild(title);
      sectionCard.appendChild(description);
      sectionCard.appendChild(list);
      container.appendChild(sectionCard);
      sectionNodes.push(sectionCard);

      if (sectionIndex === 0) {
        pill.classList.add("is-active");
      }
    });

    if (typeof IntersectionObserver !== "undefined" && sectionNodes.length) {
      var observer = new IntersectionObserver(
        function (entries) {
          entries.forEach(function (entry) {
            if (!entry.isIntersecting) {
              return;
            }
            pills.forEach(function (pill) {
              pill.classList.toggle("is-active", pill.dataset.target === entry.target.id);
            });
          });
        },
        {
          threshold: 0.45,
          rootMargin: "-110px 0px -42% 0px"
        }
      );

      sectionNodes.forEach(function (node) {
        observer.observe(node);
      });
    }
  }

  function initSkillsPage() {
    var container = byId("skills-grid");
    var skills = window.SKILLS;

    if (!container || !isArray(skills)) {
      return;
    }

    skills.forEach(function (skill) {
      var card = document.createElement("article");
      card.className = "card reveal";

      var body = document.createElement("div");
      body.className = "card-body";

      var name = document.createElement("h3");
      name.textContent = skill.name;

      var description = document.createElement("p");
      description.textContent = skill.description;

      var actions = document.createElement("div");
      actions.className = "card-actions";

      var download = document.createElement("a");
      download.className = "btn-inline";
      download.href = "skills/" + skill.filename;
      download.setAttribute("download", skill.filename);
      download.textContent = "Download";

      actions.appendChild(download);
      if (skill.contentPath || skill.content) {
        var view = document.createElement("a");
        view.className = "btn-inline";
        view.href = "view.html?type=skill&id=" + encodeURIComponent(skill.id);
        view.textContent = "View";
        actions.appendChild(view);
      }
      body.appendChild(name);
      body.appendChild(description);
      body.appendChild(actions);
      card.appendChild(body);
      container.appendChild(card);
    });
  }

  function initConnectorsPage() {
    var container = byId("connectors-grid");
    var connectors = window.CONNECTORS;

    if (!container || !isArray(connectors)) {
      return;
    }

    connectors.forEach(function (connector) {
      var card = document.createElement("article");
      card.className = "card reveal";

      var body = document.createElement("div");
      body.className = "card-body";

      var name = document.createElement("h3");
      name.textContent = connector.name;

      var description = document.createElement("p");
      description.textContent = connector.description;

      var actions = document.createElement("div");
      actions.className = "card-actions";

      var view = document.createElement("a");
      view.className = "btn-inline";
      view.href = "view.html?type=connector&id=" + encodeURIComponent(connector.id);
      view.textContent = "View guide";

      actions.appendChild(view);
      body.appendChild(name);
      body.appendChild(description);
      body.appendChild(actions);
      card.appendChild(body);
      container.appendChild(card);
    });
  }

  function initSetupPage() {
    var target = byId("setup-content");
    if (!target || !window.SETUP_CONTENT_PATH) {
      return;
    }

    loadTextContent(window.SETUP_CONTENT_PATH)
      .then(function (text) {
        target.innerHTML = renderMarkdown(text);
      })
      .catch(function () {
        target.textContent = "The setup guide could not be loaded.";
      });
  }

  function initScriptsPage() {
    var tabs = document.querySelectorAll("[data-download-platform]");
    var panels = document.querySelectorAll("[data-download-panel]");

    if (!tabs.length || !panels.length) {
      return;
    }

    function selectPlatform(platform) {
      tabs.forEach(function (tab) {
        var isSelected = tab.dataset.downloadPlatform === platform;
        tab.classList.toggle("is-active", isSelected);
        tab.setAttribute("aria-selected", String(isSelected));
      });

      panels.forEach(function (panel) {
        panel.hidden = panel.dataset.downloadPanel !== platform;
      });
    }

    tabs.forEach(function (tab) {
      tab.addEventListener("click", function () {
        selectPlatform(tab.dataset.downloadPlatform);
      });
    });

    var userAgent = navigator.userAgent || "";
    var platform = navigator.userAgentData && navigator.userAgentData.platform
      ? navigator.userAgentData.platform
      : navigator.platform || "";
    var defaultPlatform = /win/i.test(platform) || /windows/i.test(userAgent) ? "windows" : "macos";
    selectPlatform(defaultPlatform);
  }

  function initHomeworkPage() {
    var container = byId("homework-card");
    var homework = window.HOMEWORK;
    var skill = isArray(window.SKILLS) && homework
      ? window.SKILLS.find(function (entry) { return entry.id === homework.skillId; })
      : null;

    if (!container || !skill || !homework) {
      return;
    }

    var card = document.createElement("article");
    card.className = "card reveal";
    var body = document.createElement("div");
    body.className = "card-body";
    var name = document.createElement("h2");
    name.textContent = skill.name;
    var description = document.createElement("p");
    description.textContent = homework.framing;
    var actions = document.createElement("div");
    actions.className = "card-actions";
    var view = document.createElement("a");
    view.className = "btn-inline";
    view.href = "view.html?type=skill&id=" + encodeURIComponent(skill.id);
    view.textContent = "View";
    var download = document.createElement("a");
    download.className = "btn-inline";
    download.href = "skills/" + skill.filename;
    download.setAttribute("download", skill.filename);
    download.textContent = "Download";
    actions.appendChild(view);
    actions.appendChild(download);
    body.appendChild(name);
    body.appendChild(description);
    body.appendChild(actions);
    card.appendChild(body);
    container.appendChild(card);
  }

  function renderNotFound(target, backHref, backLabel) {
    target.innerHTML = "";

    var wrap = document.createElement("section");
    wrap.className = "card not-found";

    var title = document.createElement("h1");
    title.className = "page-title";
    title.textContent = "Content not found";

    var text = document.createElement("p");
    text.textContent = "The requested item could not be found. Please return to the list and choose another entry.";

    var link = document.createElement("a");
    link.href = backHref;
    link.textContent = backLabel;

    wrap.appendChild(title);
    wrap.appendChild(text);
    wrap.appendChild(link);
    target.appendChild(wrap);
  }

  function initViewerPage() {
    var target = byId("viewer-content");
    if (!target) {
      return;
    }

    var params = new URLSearchParams(window.location.search);
    var type = params.get("type");
    var id = params.get("id");

    var list;
    var backHref;
    var backLabel;

    if (type === "skill") {
      list = window.SKILLS;
      backHref = "skills.html";
      backLabel = "Back to Skills";
    } else if (type === "connector") {
      list = window.CONNECTORS;
      backHref = "connectors.html";
      backLabel = "Back to Connectors";
    } else {
      renderNotFound(target, "index.html", "Back to Home");
      return;
    }

    if (!isArray(list)) {
      renderNotFound(target, backHref, backLabel);
      return;
    }

    var item = list.find(function (entry) {
      return entry.id === id;
    });

    if (!item) {
      renderNotFound(target, backHref, backLabel);
      return;
    }

    var header = document.createElement("div");
    header.className = "viewer-header";

    var headingWrap = document.createElement("div");
    var heading = document.createElement("h1");
    heading.className = "page-title";
    heading.textContent = item.name;

    var subtitle = document.createElement("p");
    subtitle.className = "page-subtitle";
    subtitle.textContent = item.description || "";

    headingWrap.appendChild(heading);
    headingWrap.appendChild(subtitle);

    var actions = document.createElement("div");
    actions.className = "viewer-actions";

    var back = document.createElement("a");
    back.className = "btn";
    back.href = backHref;
    back.textContent = backLabel;
    actions.appendChild(back);

    if (type === "skill" && item.filename) {
      var download = document.createElement("a");
      download.className = "btn";
      download.href = "skills/" + item.filename;
      download.setAttribute("download", item.filename);
      download.textContent = "Download";
      actions.appendChild(download);
    }

    header.appendChild(headingWrap);
    header.appendChild(actions);

    var panel = document.createElement("section");
    panel.className = "code-panel viewer-panel";

    var copyButton = document.createElement("button");
    copyButton.type = "button";
    copyButton.className = "copy-btn viewer-copy";
    copyButton.textContent = "Copy all";
    copyButton.dataset.defaultLabel = "Copy all";

    var scrollWrap = document.createElement("div");
    scrollWrap.className = "code-scroll";

    var pre = document.createElement("pre");
    var markdown = document.createElement("article");
    markdown.className = "markdown-body";

    function renderViewerContent(text) {
      var rendered = renderMarkdown(text);
      if (rendered) {
        markdown.innerHTML = rendered;
        if (pre.parentNode === scrollWrap) {
          scrollWrap.removeChild(pre);
        }
        if (markdown.parentNode !== scrollWrap) {
          scrollWrap.appendChild(markdown);
        }
      } else {
        pre.textContent = text;
        if (markdown.parentNode === scrollWrap) {
          scrollWrap.removeChild(markdown);
        }
        if (pre.parentNode !== scrollWrap) {
          scrollWrap.appendChild(pre);
        }
      }
    }

    var contentText = item.content || "";
    if (item.contentPath) {
      pre.textContent = "Loading content...";
      scrollWrap.appendChild(pre);
      copyButton.textContent = "Loading";
      copyButton.disabled = true;

      loadTextContent(item.contentPath)
        .then(function (text) {
          contentText = text;
          renderViewerContent(text);
          copyButton.textContent = "Copy all";
          copyButton.disabled = false;
        })
        .catch(function () {
          renderViewerContent(contentText || "Content could not be loaded.");
          copyButton.textContent = contentText ? "Copy all" : "Unavailable";
          copyButton.disabled = !contentText;
        });
    } else {
      renderViewerContent(contentText);
    }

    copyButton.addEventListener("click", function () {
      copyText(contentText, copyButton);
    });

    panel.appendChild(copyButton);
    panel.appendChild(scrollWrap);

    target.appendChild(header);
    target.appendChild(panel);
  }

  function initPromptMetaPage() {
    var pre = byId("prompt-source-content");
    var copyButton = byId("prompt-source-copy");

    if (!pre || !copyButton) {
      return;
    }

    fetch("prompt-source.txt")
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Unable to load prompt source");
        }
        return response.text();
      })
      .then(function (text) {
        pre.textContent = text;
        copyButton.addEventListener("click", function () {
          copyText(text, copyButton);
        });
      })
      .catch(function () {
        pre.textContent = "Prompt source could not be loaded in this context. Serve the folder over HTTP to enable file loading.";
      });
  }

  document.addEventListener("DOMContentLoaded", function () {
    setCurrentYear();
    setActiveHeaderLink();

    initPromptsPage();
    initSkillsPage();
    initConnectorsPage();
    initSetupPage();
    initScriptsPage();
    initHomeworkPage();
    initViewerPage();
    initPromptMetaPage();

    addRevealAnimations();
  });
})();
