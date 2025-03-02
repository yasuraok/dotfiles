# refs: https://errormaker.blog.fc2.com/blog-entry-65.html

# レジストリのベースパスの定義
$regPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"

# 定数の定義
$INTERVAL_START = -5
$INTERVAL_END   = 5
$NOTIFICATIONS_ON = 1

while ($true) {
    Write-Output "Starting script iteration at $(Get-Date)"
    # 現在時刻の取得
    $now = Get-Date
    Write-Output "Current time: $now"

    # -5時間, +5時間後の時刻取得と「時」の部分だけ抽出
    $startHour = ($now.AddHours($INTERVAL_START)).Hour
    $endHour   = ($now.AddHours($INTERVAL_END)).Hour
    Write-Output "Calculated Active Hours: Start = $startHour, End = $endHour"

    # レジストリキーの更新（キーが存在しない場合は作成）
    Write-Output "Updating registry at path $regPath"
    New-ItemProperty -Path $regPath -Name "RestartNotificationsAllowed2" -Value $NOTIFICATIONS_ON -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $regPath -Name "ActiveHoursStart" -Value $startHour -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $regPath -Name "ActiveHoursEnd" -Value $endHour -PropertyType DWord -Force | Out-Null
    Write-Output "Registry updated successfully."

    # 1時間待機
    Write-Output "Sleeping for 1 hour..."
    Start-Sleep -Seconds 3600
}
