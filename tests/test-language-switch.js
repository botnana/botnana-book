const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const vm = require("node:vm");

const repositoryRoot = path.resolve(__dirname, "..");

function renderSwitch(scriptPath, language, pathToRoot) {
    let insertedElement;
    const menu = {
        prepend(element) {
            insertedElement = element;
        },
    };
    const document = {
        readyState: "complete",
        documentElement: { lang: language },
        querySelector(selector) {
            assert.equal(selector, "#mdbook-menu-bar .right-buttons");
            return menu;
        },
        getElementById(id) {
            assert.equal(id, "mdbook-language-switch");
            return null;
        },
        createElement(tagName) {
            assert.equal(tagName, "a");
            return {
                attributes: {},
                setAttribute(name, value) {
                    this.attributes[name] = value;
                },
            };
        },
        addEventListener() {
            assert.fail("the switch should render immediately after mdBook loads it");
        },
    };

    const source = fs.readFileSync(path.join(repositoryRoot, scriptPath), "utf8");
    vm.runInNewContext(source, { document, path_to_root: pathToRoot });
    assert.ok(insertedElement, `${scriptPath} did not add a language switch`);
    return insertedElement;
}

for (const scriptPath of ["en-us/language-switch.js", "zh-tw/language-switch.js"]) {
    const englishRoot = renderSwitch(scriptPath, "en", "");
    assert.equal(englishRoot.href, "../");
    assert.equal(englishRoot.textContent, "繁體中文");
    assert.equal(englishRoot.hreflang, "zh-TW");

    const englishNested = renderSwitch(scriptPath, "en", "../");
    assert.equal(englishNested.href, "../../");

    const chineseRoot = renderSwitch(scriptPath, "zh-TW", "");
    assert.equal(chineseRoot.href, "en-us/");
    assert.equal(chineseRoot.textContent, "English");
    assert.equal(chineseRoot.hreflang, "en");

    const chineseNested = renderSwitch(scriptPath, "zh-TW", "../");
    assert.equal(chineseNested.href, "../en-us/");

    for (const languageSwitch of [englishRoot, englishNested, chineseRoot, chineseNested]) {
        assert.equal(languageSwitch.id, "mdbook-language-switch");
        assert.equal(languageSwitch.className, "icon-button language-switch");
        assert.equal(languageSwitch.attributes["aria-label"], languageSwitch.title);
    }
}

assert.deepEqual(
    fs.readFileSync(path.join(repositoryRoot, "en-us/language-switch.js")),
    fs.readFileSync(path.join(repositoryRoot, "zh-tw/language-switch.js")),
    "language switch implementations must stay identical",
);

console.log("language switch tests passed");
