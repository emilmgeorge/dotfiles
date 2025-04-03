function get_leetcode_lang_ext() {
	const LANG_EXT_MAP = {
		'C++': '.cpp',
		'Java': '.java',
		'Python': '.py',
		'Python3': '.py',
		'C': '.c',
		'C#': '.cs',
		'JavaScript': '.js',
		'TypeScript': '.ts',
		'PHP': '.php',
		'Swift': '.swift',
		'Kotlin': '.kt',
		'Dart': '.dart',
		'Go': '.go',
		'Ruby': '.rb',
		'Scala': '.scala',
		'Rust': '.rs',
		'Racket': '.rkt',
		'Erlang': '.erl',
		'Elixir': '.ex',
		'Text': '.txt',
	}
	var lang = tri.dom.getElemsBySelector('#editor button', [(element) => {
		return LANG_EXT_MAP.hasOwnProperty(element.innerText)
	}])
	if(lang.some(a => typeof a.innerText !== 'undefined'))
		lang = lang[0].innerText
	else
		lang = 'Text'
	return [lang, LANG_EXT_MAP[lang]]
}

// Customized version of Tridactyl editor cmd for leetcode.
// Based on: https://github.com/tridactyl/tridactyl/blob/f9e3e5585acd6c46b986a08635026d790b66b293/src/excmds.ts#L344-L385
async function leetcode_editor() {
	var BEFORE_CODE = {
		'C++': [
			"#include <bits/stdc++.h>",
			"using namespace std;",
		],
	}
	var AFTER_CODE = {
		'C++': [
			"int main() {}",
		],
	}
	var BEFORE_MARKER = {
		'C++': "// @leet start\n",
	}
	var AFTER_MARKER = {
		'C++': "\n// @leet end\n",
	}

	const [lang, ext] = get_leetcode_lang_ext()

	if(!BEFORE_CODE.hasOwnProperty(lang))
		BEFORE_CODE[lang] = []
	if(!AFTER_CODE.hasOwnProperty(lang))
		AFTER_CODE[lang] = []
	if(!BEFORE_MARKER.hasOwnProperty(lang))
		BEFORE_MARKER[lang] = ''
	if(!AFTER_MARKER.hasOwnProperty(lang))
		BEFORE_MARKER[lang] = ''

	// Use temp file with the correct extension for the selected language.
	// Tridactyl editor command always creates a temp file with .txt extension.
	const elem = tri.dom.getLastUsedInput()
    const selector = tri.dom.getSelector(elem)
    addTridactylEditorClass(selector)

    if (!(await tri.native.nativegate())) {
        removeTridactylEditorClass(selector)
        return undefined
    }

    const beforeUnloadListener = (event) => {
        event.preventDefault()
        event.returnValue = true
    }
    window.addEventListener("beforeunload", beforeUnloadListener)

    let ans
    try {
        const editor = getEditor(elem, { preferHTML: true })
        var text = await editor.getContent()
        const pos = await editor.getCursor()

		var tmpcmd = await tri.native.run(`mktemp --suffix='${ext}'`, '')
		var file = tmpcmd.content.trim()
		if(BEFORE_MARKER[lang] !== '' && AFTER_MARKER[lang] !== '') {
			text = BEFORE_MARKER[lang] + text + AFTER_MARKER[lang]
			if(BEFORE_CODE[lang].length)
				text = '\n\n' + text
			if(AFTER_CODE[lang].length)
				text =  text + '\n'
			text = BEFORE_CODE[lang].join("\n") + text + AFTER_CODE[lang].join('\n')
		}
		tri.native.write(file, text)

        const exec = await tri.native.editor(file, ...pos)

        if (exec.code == 0) {
			var code = exec.content
			if(BEFORE_MARKER[lang] !== '' && AFTER_MARKER[lang] !== '') {
				const beginIdx = code.indexOf(BEFORE_MARKER[lang]);
				const endIdx = code.indexOf(AFTER_MARKER[lang], beginIdx);
				if (beginIdx !== -1 && endIdx !== -1) {
					code = code.slice(beginIdx + BEFORE_MARKER[lang].length, endIdx);
				}
			}
			await editor.setContent(code)
            await editor.setCursor(...pos)

            ans = [file, exec.content]
        } else {
            logger.debug(`Editor terminated with non-zero exit code: ${exec.code}`)
        }
    } catch (e) {
        throw new Error(`:editor failed: ${e}`)
    } finally {
        removeTridactylEditorClass(selector)
        window.removeEventListener("beforeunload", beforeUnloadListener)
        return ans
    }
}

function main() {
	var location = tri.contentLocation
	const elem = tri.dom.getLastUsedInput()
	const selector = tri.dom.getSelector(elem)
	if(location.host === "leetcode.com"
		&& location.pathname.startsWith('/problems/')
		&& selector.startsWith('#editor')) {
		leetcode_editor()
	} else {
		tri.excmds.editor()
	}
}

main()
