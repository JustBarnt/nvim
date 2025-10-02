local Cpp = {}

local function open_url(url)
  local os_name = vim.uv.os_uname().sysname
  local cm

  if os_name == "Linux" then
    cmd = string.format('xdg-open "%s"', url)
  elseif os_name == "Darwin" then
    cmd = string.format('open "%s"', url)
  elseif os_name:match "Windows" then
    cmd = string.format('start "%s"', url)
  else
    vim.notify("Unsupported OS: " .. os_name, vim.log.levels.ERROR)
    return
  end
  vim.fn.system(cmd)
end

-- Common Windows API headers and their corresponding doc paths
local api_map = {
  -- Winsock
  ["WSAStartup"] = "winsock/nf-winsock-wsastartup",
  ["WSACleanup"] = "winsock/nf-winsock-wsacleanup",
  ["socket"] = "winsock2/nf-winsock2-socket",
  ["bind"] = "winsock/nf-winsock-bind",
  ["listen"] = "winsock2/nf-winsock2-listen",
  ["accept"] = "winsock2/nf-winsock2-accept",
  ["connect"] = "winsock2/nf-winsock2-connect",
  ["send"] = "winsock2/nf-winsock2-send",
  ["recv"] = "winsock2/nf-winsock2-recv",
  ["closesocket"] = "winsock/nf-winsock-closesocket",

  -- Windows Core
  ["CreateWindow"] = "winuser/nf-winuser-createwindowa",
  ["CreateWindowEx"] = "winuser/nf-winuser-createwindowexa",
  ["DestroyWindow"] = "winuser/nf-winuser-destroywindow",
  ["ShowWindow"] = "winuser/nf-winuser-showwindow",
  ["UpdateWindow"] = "winuser/nf-winuser-updatewindow",
  ["GetMessage"] = "winuser/nf-winuser-getmessage",
  ["TranslateMessage"] = "winuser/nf-winuser-translatemessage",
  ["DispatchMessage"] = "winuser/nf-winuser-dispatchmessage",
  ["PostQuitMessage"] = "winuser/nf-winuser-postquitmessage",
  ["DefWindowProc"] = "winuser/nf-winuser-defwindowproca",
  ["RegisterClass"] = "winuser/nf-winuser-registerclassa",
  ["RegisterClassEx"] = "winuser/nf-winuser-registerclassexa",

  -- File I/O
  ["CreateFile"] = "fileapi/nf-fileapi-createfilea",
  ["ReadFile"] = "fileapi/nf-fileapi-readfile",
  ["WriteFile"] = "fileapi/nf-fileapi-writefile",
  ["CloseHandle"] = "handleapi/nf-handleapi-closehandle",
  ["DeleteFile"] = "fileapi/nf-fileapi-deletefilea",
  ["GetFileSize"] = "fileapi/nf-fileapi-getfilesize",

  -- Memory
  ["VirtualAlloc"] = "memoryapi/nf-memoryapi-virtualalloc",
  ["VirtualFree"] = "memoryapi/nf-memoryapi-virtualfree",
  ["HeapAlloc"] = "heapapi/nf-heapapi-heapalloc",
  ["HeapFree"] = "heapapi/nf-heapapi-heapfree",

  -- Process/Thread
  ["CreateProcess"] = "processthreadsapi/nf-processthreadsapi-createprocessa",
  ["CreateThread"] = "processthreadsapi/nf-processthreadsapi-createthread",
  ["ExitProcess"] = "processthreadsapi/nf-processthreadsapi-exitprocess",
  ["TerminateProcess"] = "processthreadsapi/nf-processthreadsapi-terminateprocess",
  ["WaitForSingleObject"] = "synchapi/nf-synchapi-waitforsingleobject",

  -- Add more as needed...
}

Cpp.setup = function()
  -- Approach 1: Direct lookup from map
  vim.keymap.set("n", "gwd", function()
    local word = vim.fn.expand "<cword>"

    local doc_path = api_map[word]
    if doc_path then
      local url = string.format("https://learn.microsoft.com/en-us/windows/win32/api/%s", doc_path)
      open_url(url)
    else
      print(string.format("No documentation mapping found for: %s", word))
    end
  end, { desc = "Open Windows API docs (direct lookup)" })
end

return Cpp
