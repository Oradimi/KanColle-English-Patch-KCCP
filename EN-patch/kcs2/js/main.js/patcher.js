const { readFileSync } = require("fs")
const { join } = require("path")

const fs = require("fs")
const rawTextTL = fs.readdirSync(join(__dirname, './ignore-raw_text_translations'))
const rawTextTLRegex = fs.readdirSync(join(__dirname, './ignore-raw_text_translations_regex'))
const translations = Object.create(null)
const regexreplacements = []

for (const file of rawTextTL)
    for (const [k,v] of Object.entries(JSON.parse(readFileSync(join(__dirname, join('./ignore-raw_text_translations', file))))))
        translations[k] = v

for (const file of rawTextTLRegex)
    regexreplacements.push(...Object.entries(JSON.parse(readFileSync(join(__dirname, join('./ignore-raw_text_translations_regex', file))))))

module.exports = (file, contents) => {
    return contents + `;
var KCT_TLS = ${JSON.stringify(translations)}
var KCT_REPLACEMENTS = ${JSON.stringify(regexreplacements)}

Object.defineProperty(PIXI.Text.prototype, "text", {  get() { return this._text; }, set(text) {
        const replaced = KCT_TLS[text]
        if (replaced !== undefined)
            text = replaced
        else if (text != null) {
            for (const [from, to] of KCT_REPLACEMENTS)
                text = text.replace(new RegExp(from, "g"), to)
        }
        text = String(text === '' || text === null || text === undefined ? ' ' : text);

        if (this._text === text)
            return;
        
        this._text = text;
        this.dirty = true;
}})
    `
}