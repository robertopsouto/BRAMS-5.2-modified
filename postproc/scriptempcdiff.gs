* gera imagem da temperatura
'clear'
'set mpdset brmap_hires'
'open continuo.ctl'
'open interrupcao.ctl'
'paletatempdiff.gs'
'BTR01.gs'
'set gxout shaded'
'd tempc.1-tempc.2'
'set gxout contour'
'set cint 80'
'd tempc.1-tempc.2'
'draw title Temperatura'
'cbarn.gs'
'printim brams_domain.png white'
*'gxprint medium_size.png white'
'set rbcols'


