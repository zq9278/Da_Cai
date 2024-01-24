------------------------------------
-- 提示
-- 如果使用其他Lua编辑工具编辑此文档，请将VisualTFT软件中打开的此文件编辑器视图关闭，
-- 因为VisualTFT具有自动保存功能，其他软件修改时不能同步到VisualTFT编辑视图，
-- VisualTFT定时保存时，其他软件修改的内容将被恢复。
-- Attention
-- If you use other Lua Editor to edit this file, please close the file editor view
-- opened in the VisualTFT, Because VisualTFT has an automatic save function,
-- other Lua Editor cannot be synchronized to the VisualTFT edit view when it is modified.
-- When VisualTFT saves regularly, the content modified by other Lua Editor will be restored.
------------------------------------

--下面列出了常用的回调函数
--更多功能请阅读<<LUA脚本API.pdf>>

--初始化函数
--function on_init()
--end

--定时回调函数，系统每隔1秒钟自动调用。
--function on_systick()
--end

--定时器超时回调函数，当设置的定时器超时时，执行此回调函数，timer_id为对应的定时器ID
--function on_timer(timer_id)
--end

--用户通过触摸修改控件后，执行此回调函数。
--点击按钮控件，修改文本控件、修改滑动条都会触发此事件。
--function on_control_notify(screen,control,value)
--end

--当画面切换时，执行此回调函数，screen为目标画面。
--function on_screen_change(screen)
--end
--测试tag
--曲线控件绘画指令EE B1 32 00 03（页面id） 00 02（控件id） 00 00（通道id） 01（数据位长度） 11（温度十六进制） FF FC FF FF
--加热：EE B1 32 00 03 00 02 00 00 01 2D FF FC FF FF
--脉动：EE B1 32 00 07 00 02 00 00 01 05 FF FC FF FF
--自动加热：EE B1 32 00 0C 00 02 00 00 01 2D FF FC FF FF
--自动脉动：EE B1 32 00 0C 00 07 00 00 01 05 FF FC FF FF
--文本控件：EE B1 10 00 03（页面id） 00 02（控件id） 31（数据位1：数值是1） 30（数据位1：数值是） FF FC FF FF
--










function on_init()
        start_timer(4, 200, 0, 0) --开启定时器4，超时时间100ms ，检查标志位
end

uart_free_protocol = 0
local Func_lampState = 0x01
local Func_lampLight = 0x02
local cmd_head = 0x5A --帧头
local buff = {}       --缓冲区
local cmd_length = 0  --帧长度
local data_length = 0
local cmd_head_tag = 0
-- 系统函数: 串口接收函数
-- function on_uart_recv_data(packet)
--         local recv_packet_size = (#(packet))
--         for i = 0, recv_packet_size do
--                 if packet[i] == cmd_head and cmd_head_tag == 0 then
--                         cmd_length = cmd_length + 1
--                         if cmd_length == 3 then
--                                 for i = 1, 14 do
--                                         set_value(i, 9, packet[2])
--                                 end
--                         end
--                         if (packet[1] + 2) == cmd_length then
--                                 cmd_length = 0
--                                 data_length = 0
--                                 cmd_head_tag = 0
--                         end
--                 end
--         end
-- end


--背光检测
-- function on_press(state,x,y)
--         set_backlight(100)
--         start_timer(3, 60000, 1, 0)
-- end
-- function on_systick()                  --系统函数每秒执行一次，作用检测定时器标志位是否被串口写入

-- end



--定时器中断回调函数
function on_timer(timer_id)
        if timer_id == 4 then                  --系统函数每秒执行一次，作用检测定时器标志位是否被串口写入
                value_timer0 = get_value(3, 7) --获取热敷定时器标志位数值
                if value_timer0 == 1 then
                        value = get_value(2, 6)
                        value_hot = 60 * value
                        start_timer(0, 1000, 1, value_hot) --开启定时器0，超时时间1s
                        set_value(3, 7, 0)                 --重置标志位
                end
                if value_timer0 == 2 then                  --通过按钮控制程序停止时的标志位
                        value_zero = string.format("%02d", 0)
                        set_text(3, 2, value_zero)         --清除本次数值

                        stop_timer(0)
                        change_screen(4)
                        set_value(3, 7, 0)
                end
                value_timer1 = get_value(7, 7)                 --获取脉动定时器标志位数值
                if value_timer1 == 1 then
                        value_maidong = 60 * 5                 --默认5分钟
                        start_timer(2, 1000, 1, value_maidong) --开启定时器2，超时时间1s

                        value = string.format("%02d", 5)
                        value_force = string.format("%02d", 0)
                        set_text(7, 4, value)       --设置数值
                        set_text(7, 3, value_force) --设置数值

                        set_value(7, 7, 0)          --重置标志位
                end
                if value_timer1 == 2 then
                        stop_timer(2)
                        value_zero = string.format("%03d", 0)
                        set_text(7, 2, value_zero) --清除本次数值
                        change_screen(8)
                        set_value(7, 7, 0)
                end
                value_timer2 = get_value(12, 7) --获取自动定时器标志位数值
                if value_timer2 == 1 then
                        value1 = get_value(10, 6)
                        value_auto = 60 * value1
                        start_timer(1, 1000, 1, value_auto) --开启定时器1，超时时间1s
                        set_value(12, 7, 0)                 --重置标志位
                end
                if value_timer2 == 2 then
                        stop_timer(1)
                        value_zero = string.format("%02d", 0)
                        value_zero3 = string.format("%03d", 0)
                        set_text(12, 3, value_zero)  --清除本次数值
                        set_text(12, 4, value_zero3) --清除本次数值
                        change_screen(13)
                        set_value(12, 7, 0)
                end
        end






        if timer_id == 0 then                            --定时器0超时热敷
                value_hot = value_hot - 1
                local count = math.floor(value_hot / 60) -- 计算有多少个60
                count = string.format("%02d", count)
                local result = value_hot % 60            -- 取余操作
                result = string.format("%02d", result)
                set_text(3, 4, count)
                set_text(3, 5, result)
                --当计时器定时为0时界面跳转+结束信号
                if value_hot == 0 then
                        change_screen(5)
                        set_value(3, 7, 0)
                        --界面跳转

                        --热敷停止指令（倒计时）
                        local door_buff = {}
                        door_buff[0] = 0x5A
                        door_buff[1] = 0xA5
                        door_buff[2] = 0x06
                        door_buff[3] = 0x83

                        door_buff[4] = 0x10
                        door_buff[5] = 0x30

                        door_buff[6] = 0x01

                        door_buff[7] = 0x00
                        door_buff[8] = 0x02
                        uart_send_data(door_buff)
                end
        end

        if timer_id == 1 then                             --定时器1超时自动
                value_auto = value_auto - 1
                local count = math.floor(value_auto / 60) -- 计算有多少个60
                count = string.format("%02d", count)
                local result = value_auto % 60            -- 取余操作
                result = string.format("%02d", result)
                set_text(12, 5, count)
                set_text(12, 6, result)
                --当计时器定时为0时界面跳转+结束信号
                if value_auto == 0 then
                        change_screen(14)
                        --界面跳转

                        --自动停止指令（倒计时）
                        local door_buff1 = {}
                        door_buff1[0] = 0x5A
                        door_buff1[1] = 0xA5
                        door_buff1[2] = 0x06
                        door_buff1[3] = 0x83
                        door_buff1[4] = 0x10
                        door_buff1[5] = 0x38
                        door_buff1[6] = 0x01
                        door_buff1[7] = 0x00
                        door_buff1[8] = 0x02
                        uart_send_data(door_buff1)
                        --热敷停止指令（倒计时）
                        -- local door_buff = {}
                        -- door_buff[0] = 0x5A
                        -- door_buff[1] = 0xA5
                        -- door_buff[2] = 0x06
                        -- door_buff[3] = 0x83

                        -- door_buff[4] = 0x10
                        -- door_buff[5] = 0x30

                        -- door_buff[6] = 0x01

                        -- door_buff[7] = 0x00
                        -- door_buff[8] = 0x02
                        -- uart_send_data(door_buff)

                        -- --脉动停止指令（倒计时）
                        -- local door_buff2 = {}
                        -- door_buff2[0] = 0x5A
                        -- door_buff2[1] = 0xA5
                        -- door_buff2[2] = 0x06
                        -- door_buff2[3] = 0x83
                        -- door_buff2[4] = 0x10
                        -- door_buff2[5] = 0x34
                        -- door_buff2[6] = 0x01
                        -- door_buff2[7] = 0x00
                        -- door_buff2[8] = 0x02
                        -- uart_send_data(door_buff2)
                end
        end



        if timer_id == 2 then                                --定时器2超时脉动
                value_maidong = value_maidong - 1
                local count = math.floor(value_maidong / 60) -- 计算有多少个60
                count = string.format("%02d", count)
                local result = value_maidong % 60            -- 取余操作
                result = string.format("%02d", result)
                set_text(7, 4, count)
                set_text(7, 3, result)
                --当计时器定时为0时界面跳转+结束信号
                if value_maidong == 0 then
                        change_screen(7)
                        --界面跳转
                        --脉动停止指令（倒计时）
                        local door_buff2 = {}
                        door_buff2[0] = 0x5A
                        door_buff2[1] = 0xA5
                        door_buff2[2] = 0x06
                        door_buff2[3] = 0x83
                        door_buff2[4] = 0x10
                        door_buff2[5] = 0x34
                        door_buff2[6] = 0x01
                        door_buff2[7] = 0x00
                        door_buff2[8] = 0x02
                        uart_send_data(door_buff2)
                end
        end
        if timer_id == 3 then
                set_backlight(0)
        end
end

--控件回调函数
function on_control_notify(screen, control, value)
        ---------界面0设置初值-----------
        if screen == 0 then
                --and control==1 and value==1
                --set_value(2, 4, 0) --各个界面的初值--
                --set_value(6, 5, 5)
                --set_value(10, 5, 0)
                --set_value(11, 5, 5)
                -- local value_force = string.format("%02d", 0)
                -- set_text(7, 4, value_force) --设置数值
                -- set_text(7, 3, value_force) --设置数值
        end

        ------------第2页图标----------
        if screen == 2 then
                if control == 3 and value == 0 then --控件‘减’弹起
                        value = get_value(2, 4)     --获取数值
                        value_hot = get_value(2, 6) --获取数值

                        if value > 0 then
                                value = value - 1
                        end
                        if value < 0 then
                                value = 0
                        end
                        if value_hot > 1 then
                                value_hot = value_hot - 1
                        end
                        if value_hot < 1 then
                                value_hot = 1
                        end

                        set_value(2, 4, value)
                        set_value(2, 6, value_hot)
                end
                if control == 5 and value == 0 then --控件‘加’弹起
                        value = get_value(2, 4)     --获取数值
                        value_hot = get_value(2, 6) --获取数值	
                        if value < 15 then
                                value = value + 1
                        end
                        if value > 15 then
                                value = 15
                        end
                        if value_hot < 15 then
                                value_hot = value_hot + 1
                        end
                        if value_hot > 15 then
                                value_hot = 15
                        end
                        set_value(2, 4, value)     --设置数值
                        set_value(2, 6, value_hot) --设置数值
                end

                if control == 2 and value == 0 then
                        --获取倒计时数值，并显示
                        value = get_value(2, 6)
                        value = string.format("%02d", value)
                        value_force = string.format("%02d", 0)
                        set_text(3, 4, value)       --设置数值
                        set_text(3, 5, value_force) --设置数值

                        value_zero = string.format("%02d", 0)
                        set_text(3, 2, value_zero) --热敷初数值

                        local door_buff = {}
                        door_buff[0] = 0x5A
                        door_buff[1] = 0xA5
                        door_buff[2] = 0x06
                        door_buff[3] = 0x83
                        door_buff[4] = 0x10
                        door_buff[5] = 0x41
                        door_buff[6] = 0x01
                        door_buff[7] = 0x00
                        door_buff[8] = value

                        uart_send_data(door_buff)

                        stop_timer(3) --关闭屏幕休眠定时器
                end
        end

        -----------第3页画曲线，关闭定时器（停止加热）----------------

        if screen == 3 then
                if control == 1 and value == 0 then --弹起第0页、编号1按钮
                        set_value(3, 7, 0)
                        stop_timer(0)               --关闭定时器
                        local door_buff = {}
                        door_buff[0] = 0x5A
                        door_buff[1] = 0xA5
                        door_buff[2] = 0x06
                        door_buff[3] = 0x83
                        door_buff[4] = 0x10
                        door_buff[5] = 0x30
                        door_buff[6] = 0x01
                        door_buff[7] = 0x00
                        door_buff[8] = 0x02
                        uart_send_data(door_buff)

                        value_zero = string.format("%02d", 0)
                        set_text(3, 2, value_zero) --清除本次数值
                end
        end


        ----------第6页脉动页面----------

        if screen == 6 then
                if control == 3 and value == 0 then --控件‘减’弹起
                        value = get_value(6, 5)     --获取数值
                        value_force = get_value(6, 6)
                        if value > 0 then
                                value = value - 1
                        end
                        if value < 0 then
                                value = 0
                        end

                        if value_force > 150 then
                                value_force = value_force - 50
                        end
                        if value_force < 150 then
                                value_force = 150
                        end

                        set_value(6, 5, value)
                        set_value(6, 6, value_force)
                end

                if control == 4 and value == 0 then --控件‘加’弹起
                        value = get_value(6, 5)     --获取数值
                        value_force = get_value(6, 6)
                        if value < 5 then
                                value = value + 1
                        end
                        if value > 5 then
                                value = 5
                        end
                        if value_force < 350 then
                                value_force = value_force + 50
                        end
                        if value_force > 350 then
                                value_force = 350
                        end

                        set_value(6, 5, value)
                        set_value(6, 6, value_force)
                end

                if control == 2 and value == 0 then
                        value = string.format("%02d", 5)
                        value_force = string.format("%02d", 0)
                        set_text(7, 4, value)       --设置数值
                        set_text(7, 3, value_force) --设置数值

                        value_zero = string.format("%03d", 0)
                        set_text(7, 2, value_zero) --脉动初数值

                        value = get_value(6, 6)    --获取压力数值
                        local door_buff1 = {}
                        door_buff1[0] = 0x5A
                        door_buff1[1] = 0xA5
                        door_buff1[2] = 0x06
                        door_buff1[3] = 0x83
                        door_buff1[4] = 0x10
                        door_buff1[5] = 0x05
                        door_buff1[6] = 0x01
                        door_buff1[7] = value >> 8
                        door_buff1[8] = value
                        uart_send_data(door_buff1)
                        stop_timer(3) --关闭屏幕休眠定时器
                end
        end
        ----------第7页脉动页面----------
        if screen == 7 then
                if control == 1 and value == 0 then --控件‘停止’弹起
                        --界面跳转
                        local door_buff = {}
                        door_buff[0] = 0x5A
                        door_buff[1] = 0xA5
                        door_buff[2] = 0x06
                        door_buff[3] = 0x83
                        door_buff[4] = 0x10
                        door_buff[5] = 0x34
                        door_buff[6] = 0x01
                        door_buff[7] = 0x00
                        door_buff[8] = 0x02
                        uart_send_data(door_buff)
                        stop_timer(2) --关闭定时器
                        set_value(7, 7, 0)

                        value_zero = string.format("%03d", 0)
                        set_text(7, 2, value_zero) --清除本次数值
                end
        end

        -----------第10页自动时间页面---------

        if screen == 10 then                          --第二页图标
                if control == 3 and value == 0 then   --控件‘减’弹起
                        value = get_value(10, 5)      --获取数值
                        value_auto = get_value(10, 6) --获取数值

                        if value > 0 then
                                value = value - 1
                        end
                        if value < 0 then
                                value = 0
                        end
                        if value_auto > 1 then
                                value_auto = value_auto - 1
                        end
                        if value_auto < 1 then
                                value_auto = 1
                        end
                        -- value = string.format("%02d", value)
                        -- value_hot = string.format("%02d", value_auto)
                        -- set_text(10, 5, value)      --设置数值
                        -- set_text(10, 6, value_auto) --设置数值
                        set_value(10, 5, value)
                        set_value(10, 6, value_auto)
                end

                if control == 4 and value == 0 then   --控件‘加’弹起
                        value = get_value(10, 5)      --获取数值
                        value_auto = get_value(10, 6) --获取数值	
                        if value < 15 then
                                value = value + 1
                        end
                        if value > 15 then
                                value = 15
                        end
                        if value_auto < 15 then
                                value_auto = value_auto + 1
                        end
                        if value_auto > 15 then
                                value_auto = 15
                        end

                        set_value(10, 5, value)
                        set_value(10, 6, value_auto)
                end
        end
        -----------第11也自动脉动页面---------

        if screen == 11 then                        --第二页图标
                if control == 3 and value == 0 then --控件‘减’弹起
                        value = get_value(11, 5)    --获取数值
                        value_force = get_value(11, 6)
                        if value > 0 then
                                value = value - 1
                        end
                        if value < 0 then
                                value = 0
                        end

                        if value_force > 150 then
                                value_force = value_force - 50
                        end
                        if value_force < 150 then
                                value_force = 150
                        end

                        set_value(11, 5, value)
                        set_value(11, 6, value_force)
                end

                if control == 4 and value == 0 then --控件‘加’弹起
                        value = get_value(11, 5)    --获取数值
                        value_force = get_value(11, 6)
                        if value < 5 then
                                value = value + 1
                        end
                        if value > 5 then
                                value = 5
                        end
                        if value_force < 350 then
                                value_force = value_force + 50
                        end
                        if value_force > 350 then
                                value_force = 350
                        end
                        set_value(11, 5, value)
                        set_value(11, 6, value_force)
                end
                if control == 2 and value == 0 then
                        value = get_value(10, 6) --获取倒计时数值，并显示

                        value = string.format("%02d", value)
                        value_force = string.format("%02d", 0)
                        set_text(12, 5, value)       --设置数值
                        set_text(12, 6, value_force) --设置数值

                        value_zero = string.format("%02d", 0)
                        value_zero3 = string.format("%03d", 0)
                        set_text(12, 3, value_zero)  --自动初数值
                        set_text(12, 4, value_zero3) --自动初数值


                        --                          --热敷预热开启指令
                        --                          local door_buff1 = {}
                        --                          door_buff1[0] = 0x5A
                        --                          door_buff1[1] = 0xA5
                        --                          door_buff1[2] = 0x06
                        --                          door_buff1[3] = 0x83
                        --  1
                        --                          door_buff1[4] = 0x10
                        --                          door_buff1[5] = 0x30
                        --  1
                        --                          door_buff1[6] = 0x01
                        --  1
                        --                          door_buff1[7] = 0x00
                        --                          door_buff1[8] = 0x02
                        --                          uart_send_data(door_buff)

                        value2 = get_value(11, 6) --获取压力数值
                        local door_buff = {}
                        door_buff[0] = 0x5A
                        door_buff[1] = 0xA5
                        door_buff[2] = 0x06
                        door_buff[3] = 0x83
                        door_buff[4] = 0x10
                        door_buff[5] = 0x37
                        door_buff[6] = 0x01
                        door_buff[7] = value2 >> 8
                        door_buff[8] = value2
                        uart_send_data(door_buff)
                        stop_timer(3) --关闭屏幕休眠定时器
                end
        end
        -----------第12页自动停止页面---------
        if screen == 12 then
                if control == 1 and value == 0 then --控件‘停止’弹起
                        stop_timer(1)               --关闭定时器
                        local door_buff = {}
                        door_buff[0] = 0x5A
                        door_buff[1] = 0xA5
                        door_buff[2] = 0x06
                        door_buff[3] = 0x83
                        door_buff[4] = 0x10
                        door_buff[5] = 0x38
                        door_buff[6] = 0x01
                        door_buff[7] = 0x00
                        door_buff[8] = 0x02
                        uart_send_data(door_buff)
                        set_value(12, 7, 0)
                        value_zero = string.format("%02d", 0)
                        value_zero3 = string.format("%03d", 0)
                        set_text(12, 3, value_zero)  --清除本次数值
                        set_text(12, 4, value_zero3) --清除本次数值
                end
        end

        return 1
end
