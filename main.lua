------------------------------------
-- ��ʾ
-- ���ʹ������Lua�༭���߱༭���ĵ����뽫VisualTFT����д򿪵Ĵ��ļ��༭����ͼ�رգ�
-- ��ΪVisualTFT�����Զ����湦�ܣ���������޸�ʱ����ͬ����VisualTFT�༭��ͼ��
-- VisualTFT��ʱ����ʱ����������޸ĵ����ݽ����ָ���
-- Attention
-- If you use other Lua Editor to edit this file, please close the file editor view
-- opened in the VisualTFT, Because VisualTFT has an automatic save function,
-- other Lua Editor cannot be synchronized to the VisualTFT edit view when it is modified.
-- When VisualTFT saves regularly, the content modified by other Lua Editor will be restored.
------------------------------------

--�����г��˳��õĻص�����
--���๦�����Ķ�<<LUA�ű�API.pdf>>

--��ʼ������
--function on_init()
--end

--��ʱ�ص�������ϵͳÿ��1�����Զ����á�
--function on_systick()
--end

--��ʱ����ʱ�ص������������õĶ�ʱ����ʱʱ��ִ�д˻ص�������timer_idΪ��Ӧ�Ķ�ʱ��ID
--function on_timer(timer_id)
--end

--�û�ͨ�������޸Ŀؼ���ִ�д˻ص�������
--�����ť�ؼ����޸��ı��ؼ����޸Ļ��������ᴥ�����¼���
--function on_control_notify(screen,control,value)
--end

--�������л�ʱ��ִ�д˻ص�������screenΪĿ�껭�档
--function on_screen_change(screen)
--end
--����tag
--���߿ؼ��滭ָ��EE B1 32 00 03��ҳ��id�� 00 02���ؼ�id�� 00 00��ͨ��id�� 01������λ���ȣ� 11���¶�ʮ�����ƣ� FF FC FF FF
--���ȣ�EE B1 32 00 03 00 02 00 00 01 2D FF FC FF FF
--������EE B1 32 00 07 00 02 00 00 01 05 FF FC FF FF
--�Զ����ȣ�EE B1 32 00 0C 00 02 00 00 01 2D FF FC FF FF
--�Զ�������EE B1 32 00 0C 00 07 00 00 01 05 FF FC FF FF
--�ı��ؼ���EE B1 10 00 03��ҳ��id�� 00 02���ؼ�id�� 31������λ1����ֵ��1�� 30������λ1����ֵ�ǣ� FF FC FF FF
--










function on_init()
        start_timer(4, 200, 0, 0) --������ʱ��4����ʱʱ��100ms ������־λ
end

uart_free_protocol = 0
local Func_lampState = 0x01
local Func_lampLight = 0x02
local cmd_head = 0x5A --֡ͷ
local buff = {}       --������
local cmd_length = 0  --֡����
local data_length = 0
local cmd_head_tag = 0
-- ϵͳ����: ���ڽ��պ���
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


--������
-- function on_press(state,x,y)
--         set_backlight(100)
--         start_timer(3, 60000, 1, 0)
-- end
-- function on_systick()                  --ϵͳ����ÿ��ִ��һ�Σ����ü�ⶨʱ����־λ�Ƿ񱻴���д��

-- end



--��ʱ���жϻص�����
function on_timer(timer_id)
        if timer_id == 4 then                  --ϵͳ����ÿ��ִ��һ�Σ����ü�ⶨʱ����־λ�Ƿ񱻴���д��
                value_timer0 = get_value(3, 7) --��ȡ�ȷ�ʱ����־λ��ֵ
                if value_timer0 == 1 then
                        value = get_value(2, 6)
                        value_hot = 60 * value
                        start_timer(0, 1000, 1, value_hot) --������ʱ��0����ʱʱ��1s
                        set_value(3, 7, 0)                 --���ñ�־λ
                end
                if value_timer0 == 2 then                  --ͨ����ť���Ƴ���ֹͣʱ�ı�־λ
                        value_zero = string.format("%02d", 0)
                        set_text(3, 2, value_zero)         --���������ֵ

                        stop_timer(0)
                        change_screen(4)
                        set_value(3, 7, 0)
                end
                value_timer1 = get_value(7, 7)                 --��ȡ������ʱ����־λ��ֵ
                if value_timer1 == 1 then
                        value_maidong = 60 * 5                 --Ĭ��5����
                        start_timer(2, 1000, 1, value_maidong) --������ʱ��2����ʱʱ��1s

                        value = string.format("%02d", 5)
                        value_force = string.format("%02d", 0)
                        set_text(7, 4, value)       --������ֵ
                        set_text(7, 3, value_force) --������ֵ

                        set_value(7, 7, 0)          --���ñ�־λ
                end
                if value_timer1 == 2 then
                        stop_timer(2)
                        value_zero = string.format("%03d", 0)
                        set_text(7, 2, value_zero) --���������ֵ
                        change_screen(8)
                        set_value(7, 7, 0)
                end
                value_timer2 = get_value(12, 7) --��ȡ�Զ���ʱ����־λ��ֵ
                if value_timer2 == 1 then
                        value1 = get_value(10, 6)
                        value_auto = 60 * value1
                        start_timer(1, 1000, 1, value_auto) --������ʱ��1����ʱʱ��1s
                        set_value(12, 7, 0)                 --���ñ�־λ
                end
                if value_timer2 == 2 then
                        stop_timer(1)
                        value_zero = string.format("%02d", 0)
                        value_zero3 = string.format("%03d", 0)
                        set_text(12, 3, value_zero)  --���������ֵ
                        set_text(12, 4, value_zero3) --���������ֵ
                        change_screen(13)
                        set_value(12, 7, 0)
                end
        end






        if timer_id == 0 then                            --��ʱ��0��ʱ�ȷ�
                value_hot = value_hot - 1
                local count = math.floor(value_hot / 60) -- �����ж��ٸ�60
                count = string.format("%02d", count)
                local result = value_hot % 60            -- ȡ�����
                result = string.format("%02d", result)
                set_text(3, 4, count)
                set_text(3, 5, result)
                --����ʱ����ʱΪ0ʱ������ת+�����ź�
                if value_hot == 0 then
                        change_screen(5)
                        set_value(3, 7, 0)
                        --������ת

                        --�ȷ�ָֹͣ�����ʱ��
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

        if timer_id == 1 then                             --��ʱ��1��ʱ�Զ�
                value_auto = value_auto - 1
                local count = math.floor(value_auto / 60) -- �����ж��ٸ�60
                count = string.format("%02d", count)
                local result = value_auto % 60            -- ȡ�����
                result = string.format("%02d", result)
                set_text(12, 5, count)
                set_text(12, 6, result)
                --����ʱ����ʱΪ0ʱ������ת+�����ź�
                if value_auto == 0 then
                        change_screen(14)
                        --������ת

                        --�Զ�ָֹͣ�����ʱ��
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
                        --�ȷ�ָֹͣ�����ʱ��
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

                        -- --����ָֹͣ�����ʱ��
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



        if timer_id == 2 then                                --��ʱ��2��ʱ����
                value_maidong = value_maidong - 1
                local count = math.floor(value_maidong / 60) -- �����ж��ٸ�60
                count = string.format("%02d", count)
                local result = value_maidong % 60            -- ȡ�����
                result = string.format("%02d", result)
                set_text(7, 4, count)
                set_text(7, 3, result)
                --����ʱ����ʱΪ0ʱ������ת+�����ź�
                if value_maidong == 0 then
                        change_screen(7)
                        --������ת
                        --����ָֹͣ�����ʱ��
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

--�ؼ��ص�����
function on_control_notify(screen, control, value)
        ---------����0���ó�ֵ-----------
        if screen == 0 then
                --and control==1 and value==1
                --set_value(2, 4, 0) --��������ĳ�ֵ--
                --set_value(6, 5, 5)
                --set_value(10, 5, 0)
                --set_value(11, 5, 5)
                -- local value_force = string.format("%02d", 0)
                -- set_text(7, 4, value_force) --������ֵ
                -- set_text(7, 3, value_force) --������ֵ
        end

        ------------��2ҳͼ��----------
        if screen == 2 then
                if control == 3 and value == 0 then --�ؼ�����������
                        value = get_value(2, 4)     --��ȡ��ֵ
                        value_hot = get_value(2, 6) --��ȡ��ֵ

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
                if control == 5 and value == 0 then --�ؼ����ӡ�����
                        value = get_value(2, 4)     --��ȡ��ֵ
                        value_hot = get_value(2, 6) --��ȡ��ֵ	
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
                        set_value(2, 4, value)     --������ֵ
                        set_value(2, 6, value_hot) --������ֵ
                end

                if control == 2 and value == 0 then
                        --��ȡ����ʱ��ֵ������ʾ
                        value = get_value(2, 6)
                        value = string.format("%02d", value)
                        value_force = string.format("%02d", 0)
                        set_text(3, 4, value)       --������ֵ
                        set_text(3, 5, value_force) --������ֵ

                        value_zero = string.format("%02d", 0)
                        set_text(3, 2, value_zero) --�ȷ����ֵ

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

                        stop_timer(3) --�ر���Ļ���߶�ʱ��
                end
        end

        -----------��3ҳ�����ߣ��رն�ʱ����ֹͣ���ȣ�----------------

        if screen == 3 then
                if control == 1 and value == 0 then --�����0ҳ�����1��ť
                        set_value(3, 7, 0)
                        stop_timer(0)               --�رն�ʱ��
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
                        set_text(3, 2, value_zero) --���������ֵ
                end
        end


        ----------��6ҳ����ҳ��----------

        if screen == 6 then
                if control == 3 and value == 0 then --�ؼ�����������
                        value = get_value(6, 5)     --��ȡ��ֵ
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

                if control == 4 and value == 0 then --�ؼ����ӡ�����
                        value = get_value(6, 5)     --��ȡ��ֵ
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
                        set_text(7, 4, value)       --������ֵ
                        set_text(7, 3, value_force) --������ֵ

                        value_zero = string.format("%03d", 0)
                        set_text(7, 2, value_zero) --��������ֵ

                        value = get_value(6, 6)    --��ȡѹ����ֵ
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
                        stop_timer(3) --�ر���Ļ���߶�ʱ��
                end
        end
        ----------��7ҳ����ҳ��----------
        if screen == 7 then
                if control == 1 and value == 0 then --�ؼ���ֹͣ������
                        --������ת
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
                        stop_timer(2) --�رն�ʱ��
                        set_value(7, 7, 0)

                        value_zero = string.format("%03d", 0)
                        set_text(7, 2, value_zero) --���������ֵ
                end
        end

        -----------��10ҳ�Զ�ʱ��ҳ��---------

        if screen == 10 then                          --�ڶ�ҳͼ��
                if control == 3 and value == 0 then   --�ؼ�����������
                        value = get_value(10, 5)      --��ȡ��ֵ
                        value_auto = get_value(10, 6) --��ȡ��ֵ

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
                        -- set_text(10, 5, value)      --������ֵ
                        -- set_text(10, 6, value_auto) --������ֵ
                        set_value(10, 5, value)
                        set_value(10, 6, value_auto)
                end

                if control == 4 and value == 0 then   --�ؼ����ӡ�����
                        value = get_value(10, 5)      --��ȡ��ֵ
                        value_auto = get_value(10, 6) --��ȡ��ֵ	
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
        -----------��11Ҳ�Զ�����ҳ��---------

        if screen == 11 then                        --�ڶ�ҳͼ��
                if control == 3 and value == 0 then --�ؼ�����������
                        value = get_value(11, 5)    --��ȡ��ֵ
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

                if control == 4 and value == 0 then --�ؼ����ӡ�����
                        value = get_value(11, 5)    --��ȡ��ֵ
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
                        value = get_value(10, 6) --��ȡ����ʱ��ֵ������ʾ

                        value = string.format("%02d", value)
                        value_force = string.format("%02d", 0)
                        set_text(12, 5, value)       --������ֵ
                        set_text(12, 6, value_force) --������ֵ

                        value_zero = string.format("%02d", 0)
                        value_zero3 = string.format("%03d", 0)
                        set_text(12, 3, value_zero)  --�Զ�����ֵ
                        set_text(12, 4, value_zero3) --�Զ�����ֵ


                        --                          --�ȷ�Ԥ�ȿ���ָ��
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

                        value2 = get_value(11, 6) --��ȡѹ����ֵ
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
                        stop_timer(3) --�ر���Ļ���߶�ʱ��
                end
        end
        -----------��12ҳ�Զ�ֹͣҳ��---------
        if screen == 12 then
                if control == 1 and value == 0 then --�ؼ���ֹͣ������
                        stop_timer(1)               --�رն�ʱ��
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
                        set_text(12, 3, value_zero)  --���������ֵ
                        set_text(12, 4, value_zero3) --���������ֵ
                end
        end

        return 1
end
