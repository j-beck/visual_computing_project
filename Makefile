all:
	/opt/processing/processing-java --sketch=image_processing2 --run

mile:
	/opt/processing/processing-java --sketch=milestone2 --run
	
style:
	astyle -A8 image_processing2/*.pde milestone2/*.pde
