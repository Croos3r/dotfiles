function bat --wraps=batcat --description 'alias bat=batcat'
  # Debian/older Ubuntu ship the binary as batcat, newer Ubuntu as bat
  if command -q batcat
    batcat $argv
  else
    command bat $argv
  end
end
