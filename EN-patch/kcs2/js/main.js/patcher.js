const { readFileSync } = require("fs")
const { join } = require("path")

const fs = require("fs")
const rawTextTL = fs.readdirSync(join(__dirname, './ignore-raw_text_translations'))
const rawTextTLRegex = fs.readdirSync(join(__dirname, './ignore-raw_text_translations_regex'))
const patcherContents = fs.readFileSync(join(__dirname, './ignore-patcher_contents.js'), { encoding: 'utf8', flag: 'r' })
const translations = Object.create(null)
const regexreplacements = []

for (const file of rawTextTL)
    for (const [k,v] of Object.entries(JSON.parse(readFileSync(join(__dirname, join('./ignore-raw_text_translations', file))))))
        translations[k] = v

for (const file of rawTextTLRegex)
    regexreplacements.push(...Object.entries(JSON.parse(readFileSync(join(__dirname, join('./ignore-raw_text_translations_regex', file))))))

module.exports = (file, contents) => {
    return contents + `;\n
const KCT_TLS = ${JSON.stringify(translations)};\n
const KCT_REPLACEMENTS = ${JSON.stringify(regexreplacements)};\n
    ` + patcherContents
}
