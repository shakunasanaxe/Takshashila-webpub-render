local utils = require("pandoc.utils")

function escape_latex(s)
	local replacements = {
		["\\"] = "\\textbackslash{}",
		["%%"] = "\\%",
		["%"] = "\\%",
		["&"] = "\\&",
		["#"] = "\\#",
		["_"] = "\\_",
		["{"] = "\\{",
		["}"] = "\\}",
		["$"] = "\\$",
		["^"] = "\\^{}",
		["~"] = "\\~{}",
	}
	return (s:gsub(".", replacements))
end

function Div(el)
	if FORMAT:match("latex") and el.classes:includes("aside") then
		if el.classes:includes("aside-btn") then
			return {}
		end

		local text = utils.stringify(el)
		text = escape_latex(text)

		if #text > 400 then
			return {
				pandoc.RawBlock("latex", "\\begin{inlinenote}"),
				el.content[1],
				pandoc.RawBlock("latex", "\\end{inlinenote}"),
			}
		end

		return {
			pandoc.RawBlock("latex", "\\aside{"),
			el.content[1],
			pandoc.RawBlock("latex", "}"),
		}
	end

	return el
end
