# Tabi
Tabi can download ranobe from baka-tsuki and save it as fb2 book.

Dependencies: 
1. nokogiri
2. mini_magick (if you want to compress illustrations)

Config example:
```yaml
link: 'https://www.baka-tsuki.org/project/index.php?title=ProjectName:VolumeN'
filename: 'config_test.result.fb2'
images: true
compress_images: true
```

Run command:
```bash
ruby tabi.rb
```
