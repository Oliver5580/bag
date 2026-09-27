$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8642/')
$listener.Start()
Write-Output "serving $root at http://localhost:8642/"
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  try {
    $path = $ctx.Request.Url.AbsolutePath
    if ($path -eq '/') { $path = '/index.html' }
    $rel = $path.TrimStart('/') -replace '/', '\'
    $file = Join-Path $root $rel
    if ((Test-Path $file -PathType Leaf) -and ($file.StartsWith($root))) {
      $ext = [System.IO.Path]::GetExtension($file).ToLower()
      $mime = @{ '.html' = 'text/html; charset=utf-8'; '.css' = 'text/css; charset=utf-8'; '.js' = 'text/javascript; charset=utf-8'; '.mp4' = 'video/mp4'; '.webm' = 'video/webm'; '.png' = 'image/png'; '.jpg' = 'image/jpeg' }[$ext]
      if (-not $mime) { $mime = 'application/octet-stream' }
      $bytes = [System.IO.File]::ReadAllBytes($file)
      $ctx.Response.ContentType = $mime
      $ctx.Response.Headers['Cache-Control'] = 'no-cache'
      $ctx.Response.ContentLength64 = $bytes.Length
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $ctx.Response.StatusCode = 404
      $msg = [System.Text.Encoding]::UTF8.GetBytes('404 not found')
      $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
    }
  } catch {
    Write-Output "ERR: $_"
  }
  try { $ctx.Response.OutputStream.Close() } catch {}
}
