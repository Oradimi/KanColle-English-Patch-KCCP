const { readFileSync } = require("fs")
const { join } = require("path")

const translations = Object.create(null)
const regexreplacements = []

for (const file of ["./ignore-ship_names.json","./ignore-equips.json","./ignore-ship_types.json","./ignore-stats.json","./ignore-terms.json","./ignore-exped_desc.json","./ignore-sortie_desc.json","./ignore-map.json","./ignore-event.json"])
    for (const [k,v] of Object.entries(JSON.parse(readFileSync(join(__dirname, file)))))
        translations[k] = v

for (const file of ["./ignore-_regex_stats.json","./ignore-_regex_equips.json","./ignore-_regex_terms.json","./ignore-_regex_ship.json","./ignore-_regex_map.json","./ignore-_regex_combined_errors.json"])
    regexreplacements.push(...Object.entries(JSON.parse(readFileSync(join(__dirname, file)))))

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