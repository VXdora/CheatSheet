# .NET Framework�̐錾
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Windows API�̐錾
Add-Type -AssemblyName System.Windows.Forms
$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

# MoveTo
# Desc: �}�E�X�|�C���^�[��(x, y)�Ɉړ�
# Usage: MoveTo X Y
function MoveTo($x, $y) {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    Start-Sleep -Milliseconds 50
}

# Click
# Desc: ���N���b�N
# Usage: Click
function Click {
    $SendMouseClick::mouse_event(0x0002, 0, 0, 0, 0);
    $SendMouseClick::mouse_event(0x0004, 0, 0, 0, 0);
    Start-Sleep -Milliseconds 50
}

# MoveToClick
# Desc: �}�E�X�|�C���^�[��(x, y)�Ɉړ�
#     ��$mwt�~���b�ҋ@
#     ���N���b�N
#     ��$awt�~���b�ҋ@
# Usage: MoveToClick X Y 10 30
function MoveToClick($x, $y, $mwt=500, $awt=500) {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    Start-Sleep -Milliseconds $mwt
    $SendMouseClick::mouse_event(0x0002, 0, 0, 0, 0);
    $SendMouseClick::mouse_event(0x0004, 0, 0, 0, 0);
    Start-Sleep -Milliseconds $awt
}

# KeyInput
# Desc: �L�[���͂�������
# Usage: KeyInput "txt"
# ����L�[�F
#        ALT+x    - %x
#        Ctrl+n   - ^n
#        ENTER    - {ENTER}
#        DELETE   - {DELETE}
#        TAB      - {TAB}
function KeyInput($txt) {
    [System.Windows.Forms.SendKeys]::SendWait($txt)
    Start-Sleep -Milliseconds 50
}

MoveToClick 479 1054
MoveToClick 1894 50
MoveToClick 1709 133
MoveToClick 1000 50
KeyInput "^a{DELETE}yahoo.co.jp{ENTER}"