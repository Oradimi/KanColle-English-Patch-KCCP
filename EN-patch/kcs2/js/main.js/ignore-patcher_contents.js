const KCT_OG_PIXI_TEXT = Object.getOwnPropertyDescriptor(PIXI.Text.prototype, "text");
const KCT_OG_PIXI_STYLE = Object.getOwnPropertyDescriptor(PIXI.Text.prototype, "style");
const KCT_COMPILED_REGEX = KCT_REPLACEMENTS.map(([from, to]) => [new RegExp(from, "gm"), to]);

function kctParseTags(text) {
    let hasTags = false;
    let scale = 1, color = null, weight = null, line = null, leading = null;
    if (text && text.charCodeAt(0) === 60) {
        let i = 0;
        while (text.charCodeAt(i) === 60) {
            const end = text.indexOf('>', i);
            if (end === -1)
                break;
            hasTags = true;
            const tag = text.slice(i + 1, end);
            switch (tag[0]) {
                case 's': scale = parseFloat(tag.slice(1)) || 1; break;
                case 'c': color = tag.slice(1); break;
                case 'w': weight = tag.slice(1); break;
                case 'n': line = parseFloat(tag.slice(1)); break;
                case 'l': leading = parseFloat(tag.slice(1)); break;
            }
            i = end + 1;
        }
        text = text.slice(i);
    }
    return { text, hasTags, scale, color, weight, line, leading };
}

Object.defineProperty(PIXI.Text.prototype, "text", {
    get: KCT_OG_PIXI_TEXT.get,
    set(text) {
        // --- translation ---
        const replaced = KCT_TLS[text];
        if (replaced !== undefined) {
            text = replaced;
        } else if (text != null) {
            for (const [regex, to] of KCT_COMPILED_REGEX) {
                text = text.replace(regex, to);
            }
        }
        
        // --- parse tags ---
        text = String(text ?? " ");
        const parsed = kctParseTags(text);

        if (!this._kctBaseStyle && this.style) {
            this._kctBaseStyle = new PIXI.TextStyle(this.style);
        }

        if (!parsed.hasTags) {
            this.style = this._kctBaseStyle;
            KCT_OG_PIXI_TEXT.set.call(this, parsed.text);
            return;
        }

        const base = this._kctBaseStyle;
        if (base) {
            const next = new PIXI.TextStyle(base);

            if (parsed.scale !== 1)
                next.fontSize = base.fontSize * parsed.scale;

            if (parsed.color)
                next.fill = parsed.color;

            if (parsed.weight)
                next.fontWeight = parsed.weight;

            if (parsed.line) {
                next.wordWrap = true;
                next.wordWrapWidth = parsed.line;
            }

            if (parsed.leading)
                next.leading = parsed.leading;

            this.style = next;
        }

        // --- assign text ---
        KCT_OG_PIXI_TEXT.set.call(this, parsed.text);
    }
});
