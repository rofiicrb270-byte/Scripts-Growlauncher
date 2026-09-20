LogToConsole("`4 Made By : tesrop")
while true do

SendPacket(2, [[action|buy
item|summer_pack
]])

Sleep(100)

SendPacket(2, [[action|buy
item|summer_pack
]])

Sleep(100)

SendPacket(2, [[action|dialog_return
dialog_name|itemaddedtosucker
tilex|35|
tiley|26|
itemtoadd|200
]])

Sleep(100)

SendPacket(2, [[action|trash
|itemID|830
]])

Sleep(100)

SendPacket(2, [[action|trash
|itemID|834
]])

Sleep(100)
end