function print(...)
    LuaAuxLib.TracePrint(...)
end

function showmsg(str)
    LuaAuxLib.ShowMessage(str);
end

local thisSocket;

function QMPlugin.ConnectTo(ServerHost,ServerPort,Timeout)
	local socket = require("socket");

	Timeout = Timeout or 10
	showmsg(":正在连接"..ServerHost..":"..ServerPort.."......")
	print(":正在连接"..ServerHost..":"..ServerPort.."......")
    thisSocket = socket.tcp()
	thisSocket:settimeout(Timeout);
	pcall(thisSocket:connect(ServerHost, ServerPort));
	local peer,info = thisSocket:getpeername();

	if peer == nil then
		showmsg(":连接"..ServerHost..":"..ServerPort.."失败! ");
		print(":连接"..ServerHost..":"..ServerPort.."失败! ")
		return false;
	else
		showmsg(":连接"..ServerHost..":"..ServerPort.."成功! ");
		print(":连接"..ServerHost..":"..ServerPort.."成功! ")
		return true;
	end
end

function QMPlugin.Send(Data,timeout)
    timeout = timeout or 10
    if thisSocket ~= nil then
        thisSocket:settimeout(timeout);
		local ret,status = thisSocket:send(Data);
		if ret ~= nil then
			showmsg("发送成功!")
			print("发送成功!")
			return true;
		elseif status == "closed" then
			showmsg("连接已关闭")
			print("连接已关闭")
			return false;
		elseif status == "timeout" then 
			showmsg("发送超时!")
			print("发送超时!")
			return false;
		end
	else
		showmsg("连接已关闭")
		print("连接已关闭")
		return false;
	end
end

function QMPlugin.Receive(timeout,mode)
	timeout = timeout or 10
	mode = mode or "*l"

	if thisSocket ~= nil then
		thisSocket:settimeout(timeout);
		local data, status, partial = thisSocket:receive(mode)
		if status == "timeout" then 
			if partial ~= "" then
				return partial;
		    else
				showmsg("没数据")
				print("没数据")
				return "";
			end
		elseif status == "closed" then
			showmsg("连接已关闭")
			print("连接已关闭")
			return nil;
		else
			showmsg("接到到数据:"..data)
			print("接到到数据:"..data)
			return data;
		end
	else
		showmsg("连接已关闭")
		print("连接已关闭")
		return nil;
	end 
end


function QMPlugin.Close()
	if thisSocket~= nil then
		thisSocket:close()
	end
end 