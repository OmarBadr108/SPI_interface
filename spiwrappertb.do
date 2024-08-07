vlib work 
vlog spi6.vp ram6.vp spi_wrapper6.vp spiwrappertb.sv +cover -covercells
vsim -voptargs=+acc work.spiwrappertb -cover
add wave *
coverage save spiwrappertb.ucdb -onexit
run -all
vcover report spiwrappertb.ucdb

