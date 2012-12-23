-----Generic GlobalBan Functions
-------------------------------------

---Terrible Escape Function
function GB_Escape(str)
	local buf = string.Replace(str,"'","")
	return buf
end