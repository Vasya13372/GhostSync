--WebSocket=WebSocket or {} ;WebSocket.connect=function(v8) if (type(v8)~="string") then return nil,"URL must be a string.";end if  not (v8:match("^ws://") or v8:match("^wss://")) then return nil,"Invalid WebSocket URL. Must start with 'ws://' or 'wss://'.";end local v9=v8:gsub("^ws://",""):gsub("^wss://","");if ((v9=="") or v9:match("^%s*$")) then return nil,"Invalid WebSocket URL. No host specified.";end return {Send=function(v51) end,Close=function() end,OnMessage={},OnClose={}};end;local v1={};local v2=setmetatable;function setmetatable(v10,v11) local v12=v2(v10,v11);v1[v12]=v11;return v12;end function getrawmetatable(v14) return v1[v14];end function setrawmetatable(v15,v16) local v17=getrawmetatable(v15);table.foreach(v16,function(v52,v53) v17[v52]=v53;end);return v15;end local v3={};function sethiddenproperty(v18,v19,v20) if ( not v18 or (type(v19)~="string")) then error("Failed to set hidden property '"   .. tostring(v19)   .. "' on the object: "   .. tostring(v18) );end v3[v18]=v3[v18] or {} ;v3[v18][v19]=v20;return true;end function gethiddenproperty(v23,v24) if ( not v23 or (type(v24)~="string")) then error("Failed to get hidden property '"   .. tostring(v24)   .. "' from the object: "   .. tostring(v23) );end local v25=(v3[v23] and v3[v23][v24]) or nil ;local v26=true;return v25 or ((v24=="size_xml") and 5) ,v26;end function hookmetamethod(v27,v28,v29) assert((type(v27)=="table") or (type(v27)=="userdata") ,"invalid argument #1 to 'hookmetamethod' (table or userdata expected, got "   .. type(v27)   .. ")" ,2);assert(type(v28)=="string" ,"invalid argument #2 to 'hookmetamethod' (index: string expected, got "   .. type(v27)   .. ")" ,2);assert(type(v29)=="function" ,"invalid argument #3 to 'hookmetamethod' (function expected, got "   .. type(v27)   .. ")" ,2);local v30=v27;local v31=Xeno.debug.getmetatable(v27);v31[v28]=v29;v27=v31;return v30;end function hookmetamethod(v33,v34,v35) local v36=getgenv().getrawmetatable(v33);local v37=v36[v34];v36[v34]=v35;return v37;end debug.getproto=function(v39,v40,v41) local v42=function() return true;end;if v41 then return {v42};else return v42;end end;debug.getconstant=function(v43,v44) local v45={[1]="print",[2]=nil,[3]="Hello, world!"};return v45[v44];end;debug.getupvalues=function(v46) local v47;setfenv(v46,{print=function(v55) v47=v55;end});v46();return {v47};end;debug.getupvalue=function(v48,v49) local v50;setfenv(v48,{print=function(v56) v50=v56;end});v48();return v50;end;

WebSocket = WebSocket or {}

function WebSocket.connect(url)
    if type(url) ~= "string" then
        return nil, "URL must be a string."
    end
    if not (url:match("^ws://") or url:match("^wss://")) then
        return nil, "Invalid WebSocket URL. Must start with 'ws://' or 'wss://'."
    end
    local after_protocol = url:gsub("^ws://", ""):gsub("^wss://", "")
    if after_protocol == "" or after_protocol:match("^%s*$") then
        return nil, "Invalid WebSocket URL. No host specified."
    end
    return {
        Send = function(message)
        end,
        Close = function()
        end,
        OnMessage = {},
        OnClose = {},
    }
end
local metatables = {}

local rsetmetatable = setmetatable

setmetatable = function(tabl, meta)
    local object = rsetmetatable(tabl, meta)
    metatables[object] = meta
    return object
end
getrawmetatable = function(object)
    return metatables[object]
end
setrawmetatable = function(taaable, newmt)
    local currentmt = getrawmetatable(taaable)
    table.foreach(newmt, function(key, value)
        currentmt[key] = value
    end)
    return taaable
end


local hiddenProperties = {}
function sethiddenproperty(obj, property, value)
    if not obj or type(property) ~= "string" then
        error("Failed to set hidden property '" .. tostring(property) .. "' on the object: " .. tostring(obj))
    end
    hiddenProperties[obj] = hiddenProperties[obj] or {}
    hiddenProperties[obj][property] = value
    return true
end

function gethiddenproperty(obj, property)
    if not obj or type(property) ~= "string" then
        error("Failed to get hidden property '" .. tostring(property) .. "' from the object: " .. tostring(obj))
    end
    local value = hiddenProperties[obj] and hiddenProperties[obj][property] or nil
    local isHidden = true
    return value or (property == "size_xml" and 5), isHidden
end
function hookmetamethod(t, index, func)
	assert(type(t) == "table" or type(t) == "userdata", "invalid argument #1 to 'hookmetamethod' (table or userdata expected, got " .. type(t) .. ")", 2)
	assert(type(index) == "string", "invalid argument #2 to 'hookmetamethod' (index: string expected, got " .. type(t) .. ")", 2)
	assert(type(func) == "function", "invalid argument #3 to 'hookmetamethod' (function expected, got " .. type(t) .. ")", 2)
	local o = t
	local mt = Xeno.debug.getmetatable(t)
	mt[index] = func
	t = mt
	return o
end

hookmetamethod = function(obj, tar, rep)
    local meta = getgenv().getrawmetatable(obj)
    local save = meta[tar]
    meta[tar] = rep
    return save
end
function debug.getproto(f, index, mock)
    local proto_func = function() return true end  
    if mock then
        return { proto_func }
    else
        return proto_func
    end
end

function debug.getconstant(func, index)
    local constants = {
        [1] = "print", 
        [2] = nil,     
        [3] = "Hello, world!", 
    }
    return constants[index]
end
function debug.getupvalues(func)
    local founded
    setfenv(func, {print = function(funcc) founded = funcc end})
    func()
    return {founded}
end

function debug.getupvalue(func, num)
    local founded
    setfenv(func, {print = function(funcc) founded = funcc end})
    func()
    return founded
end

debug = {}

function debug.setupvalue(func, num, value)
    local upvalues = {}
    local founded

    -- Устанавливаем окружение функции
    setfenv(func, {
        print = function(funcc) founded = funcc end,
        set_value = function(val) upvalues[num] = val end
    })

    -- Вызываем функцию, чтобы установить upvalue
    func()

    -- Устанавливаем значение upvalue
    if founded then
        upvalues[num] = value
        return true -- Успешно изменено
    else
        return false -- Не удалось установить upvalue
    end
end

function debug.getupvalue(func, num)
    local upvalues = {}
    local founded

    -- Устанавливаем окружение функции
    setfenv(func, {
        print = function(funcc) founded = funcc end,
        get_value = function() return upvalues[num] end
    })

    -- Вызываем функцию, чтобы получить upvalue
    func()

    -- Возвращаем значение upvalue
    return upvalues[num]
end

local getcallbackvalue = {}
function getcallbackvalue(obj, prop)
    -- Check if the object has the property
    if obj and obj[prop] then
        return obj[prop]
    else
        return nil -- Return nil if the property does not exist
    end
end
-- INIT END

local file = readfile("configs/Config.txt") 
if file then
    local ua = file:match("([^\r\n]+)") 
    if ua then
        local uas = ua .. "/cxapi" 
        local oldr = request 
        getgenv().request = function(options)
            if options.Headers then
                options.Headers["User-Agent"] = uas
            else
                options.Headers = {["User-Agent"] = uas}
            end
            local response = oldr(options)
            return response
        end
 
    else
        error("failed to load config")
    end
else
    error("Failed to open config")
end
function printidentity()
	print("Current identity is 8")
 
end
