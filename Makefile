all:
	/opt/processing/processing-java --sketch=image_processing2 --run
	
style:
	astyle -A8 image_processing2/*.pde
