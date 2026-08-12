(function () {
    "use strict";

    function addLanguageSwitch() {
        const menu = document.querySelector("#mdbook-menu-bar .right-buttons");
        if (!menu || document.getElementById("mdbook-language-switch")) {
            return;
        }

        const currentLanguage = (document.documentElement.lang || "").toLowerCase();
        const isEnglish = currentLanguage.startsWith("en");
        const relativeBookRoot = typeof path_to_root === "string" ? path_to_root : "";
        const link = document.createElement("a");

        link.id = "mdbook-language-switch";
        link.className = "icon-button language-switch";
        link.href = isEnglish
            ? relativeBookRoot + "../"
            : relativeBookRoot + "en-us/";
        link.hreflang = isEnglish ? "zh-TW" : "en";
        link.lang = link.hreflang;
        link.textContent = isEnglish ? "繁體中文" : "English";
        link.title = isEnglish
            ? "閱讀繁體中文版本"
            : "Read the English edition";
        link.setAttribute("aria-label", link.title);
        menu.prepend(link);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", addLanguageSwitch, { once: true });
    } else {
        addLanguageSwitch();
    }
})();
