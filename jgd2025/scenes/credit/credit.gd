extends Node
@onready var terminal = $Terminal
signal credit_ended

func _ready():
	await get_tree().create_timer(4.0).timeout
	Transition.end()
	next_step()


func next_step() -> void:                                      
	# terminal.special_label.add_theme_font_size_override("normal_font_size", 12)      
	var tween = terminal.create_tween()
	terminal.write_art_sync(credit1, terminal.special_label, 10, false, 0.01)
	tween.tween_interval(5.0)
	tween.tween_callback(func():
		terminal.special_label2.show()
		terminal.special_label.hide()
		terminal.write_art_sync(credit2, terminal.special_label2, 10, false, 0.01)
	)
	tween.tween_interval(5.0)
	tween.tween_callback(func():
		terminal.special_label3.show()
		terminal.special_label2.hide()
		terminal.write_art_sync(credit3, terminal.special_label3, 10, false, 0.01)
	)
	tween.tween_interval(5.0)
	tween.tween_callback(func():
		terminal.special_label4.show()
		terminal.special_label3.hide()
		terminal.write_art_sync(credit4, terminal.special_label4, 10, false, 0.01)
	)
	tween.tween_interval(5.0)
	await tween.finished
	credit_ended.emit()
	Transition.set_and_start("别走", "")
	await get_tree().create_timer(0.5).timeout
	LevelManager.to_end_chat()


var credit1 = "                                                                                                                                                                                                                            
                                                                                                                                                            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                                                                                                                                                            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAA             
                                                       AAAAAAAAAAA                                                                                          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAAA             
                                           AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                               AAAAAAAA      AAA          AAAAAA                AAAAAAAAAA             
                                          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                         AAAAAAAAAAA  AAAA  AAAAAA  AAAAA   AAAAAAAAAAAAAAAAAAAAAAAA             
                                        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                    AAAAAAAA       AA          AAAAA   AA             AAAAAAAAA             
                                   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                AAAAAAAAAA   AAAAAAAAAAAAAAAAAAA   AAAAA AAA    AAAAAAAAAAA             
                                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAA                                                              AAAAAAAAA      A            AAAA   AAAAAA     AAAAAAAAAAAAA             
                             A AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAA                                                           AAAAAAAA     A AAAAAA   AAAAAAAA   A               AAAAAAAA             
                           A  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AA     AAA AAAAAAAAAAAAAAAAAAAA                                                         AAAAAAA  AA  AAAA           AAAA  AAAAAAAA   AA   AAAAAAAAA             
                         AA  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA      AAA AAAAAAAAAAAAAA AAAAA                                                        AAAAAAAAAAA  AAAAAAAA   AAAAAAA   AAAAAAAA   AAAAAAAAAAAAAA             
                        A   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAA      AA AAAAAAAAAAAAAAAA AAAA                                                       AAAAAAAAAAA  AA              AAA AAAAAA     AAAAAAAAAAAAAAA             
                       A   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAA AAA   AAA                                                      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                      A   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       AAAAAAAAAAAAAAA AAA  AAAA                                                     AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                     A    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAA                                                                                                                             
                    AA   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA    AAAA                                                                                                                            
                    A    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                            AAAAAAAAAAAAAA  AAAAAA      AAAAA               
                   A   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                            AAAAA             AAAAA    AAAAA                
                   A AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                            AAAAA              AAAAA AAAAAA                 
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                            AAAAAAAAAAAAAA      AAAAAAAAA                   
                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                            AAAAAAAAAAAAAA       AAAAAAA                    
               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                              AAAAA                 AAAAA                     
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                               AAAAA                 AAAAA                     
                AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                AAAAA                 AAAAA                     
               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AA                                                                                 AAAAA                 AAAAA                     
             AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   A                                                                                                                                       
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                                                           
           AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                           AAAA       AAAAA AAAAA       AAAA    AAAAAA         AAAAAA    AAAA              
                 A AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                          AAAAA    AAAA   AAAAA       AAAA    AAAAAAAA      AAAAAAA    AAAA              
                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                          AAAAA AAAAA    AAAAA       AAAA    AAAAAAAAA    AAAAAAAA    AAAA              
                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                           AAAAAAAA     AAAAA       AAAA    AAAAAAAAAA  AAAAAAAAA    AAAA              
                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                               AAAAAA      AAAAA       AAAA    AAAAA AAAAAAAAA  AAAA    AAAA              
                AA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                  AAAA        AAAA       AAAA    AAAAA  AAAAAAA   AAAA    AAAA              
                A   AAA   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                    AAAA         AAAAAAAAAAAAA     AAAAA   AAAAA    AAAA    AAAA              
                    AA     AAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                       AAAA           AAAAAAAAA       AAAAA            AAAA    AAAA              
                            AAAAA    AA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                                                                  
                              AAA     A AAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAA                                                                                                                                                    
                                       AAAAAAAAAAAAAAAAAAAAAAAA          AAAAA                                                                                                                                                      
                                     A AAAAAAAAAAAAAAAAAAAAAAA                                                                                                                                                                      
                                      AAAAAAAAAAAAAAAAAAAAAAAA                                                                                                           AAAAAAAAA AAA   AAA    AAAAAAAAA AAA   AAA                 
                                      AAAAAAAAAAAAAAAAAAAAAAA                                                                                                             AA  AAA   AAA AAA      AA  AAA   AAA AAA                  
                                     AAAAAAAAAAAAAAAAAAAAAAAA                                                                                                             AAAAAAA AAAAAAAAAAA    AAAAAAA AAAAAAAAAAA                
                                  A AAAAAA AAAAAAAAAAAAAAAAAA                                                                                                             AA  AAA AAA     AAA    AA  AAA AAA     AAA                
                                   AA   AAAAAAAAAAAAAAAAAAAAA                                                                                                             AAAAAAA AAAAAAAAAAA    AAAAAAA AAAAAAAAAAA                
                                     AAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                            AA  AAA     AAA        AA  AAA     AAA                    
                                   AAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                          AAAAAAAAAAAAA AAA AA   AAAAAAAAAAAAAA AA AA                
                                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                        AAAA AAAAAAAA    AAAA  AAAA AAAAAAAAA   AAAA               
                                AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                            AAA A AAAAAAA          AAA A AAAAAAAA                 
                               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                                                                                 
                               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                                                                                
                              AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                                                                                                                                                                                                                                                                                                     
"

var credit2 = "                                                                                                                       AAAA   AAA      AAAAAAAAAAA AAA     AAA    AAA      AAAA                                               
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                       AAA    AA        AAAAAAAAAAA AAAAA   AAA           AAA                                                 
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                      AAA     AAA       AAAAAAAAAAAAAAA AAAA AAA                                                              
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                      A      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                             
            AAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAAAAAAAAAA                                     AA     AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                           
            AAAAAAA                        AAAAAA  AAA     AAA            AAAAAA                                           AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAA                                                         
            AAAAAAAAAAAAA AAAAAAAAAA  AAAAAAAAAAA  AAA   AAAAAAAAAA  AAAAAAAAAAA                                          AAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAAAA        A                                                      
            AAAAAAAAAAAA   AAAAAAAA   AAAAAAAAAAA  AAA  AAAAAAA           AAAAAA                                         AAAAAAAA   AAAAA    AAAAAAAAAAAAAAAA AA                                A                             
            AAAAAA                          AAA              A   AAAAAA   AAAAAA                                       AAAAAA     AAAA       AAAAAAAAAAAAAAAAA AAA                              A                             
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAA   AA  AA   AAAAAA                                                 AA          AAAAAAAAAAAAAAAAAAAAAA                                                           
            AAAAAAAAAA                  AAAAAAAAA   A   AA   A   AA  AA   AAAAAA                                                             AA  AAAAAAAAAAAAAAAAAAAA                                                         
            AAAAAAAAA    AAAAAAAAAAAA    AAAAAAA   AA   A   AA   AA  AA   AAAAAA                                                             AA   AAAAAAAAAAAAAAAAAAAAA                AAAAAAAA   AAAAAAA                     
            AAAAAAAAA                    AAAAAAA AAAA      AAA   AA  AA   AAAAAA                                                              A   AAAAAAAAAAAAAAAAAAAAAAA                                                     
            AAAAAAAAA    AAAAAAAAAAAA    AAAAAAAAAAAAA    AAAAAAAA  A AAAAAAAAAA                                                              A    AAAAAAAAAAAAAAAAAAAAAAAAA                                                  
            AAAAAAAAA    AAAAAAAAAAAA    AAAAAAAAAA    AAAAAAAAA   AAA   AAAAAAA                                                               A   AAAA AAAAAAAAAAAAAAAAAAAAAAA                                    A          
            AAAAAAAAA                    AAAAAAA    AAAAAAAAA   AAAAAAAA  AAAAAA                                                                A  AAA  AAAAAAAAAAAAAAAAAAAAAAAAAA                              AAA           
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                   AA    AAAAAAAAAAAAAAAAAAAAAA   AAAA                      AAAA              
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                  AA      AAAAAAAAAAAAAAAAA AAAA      AAAA               AAA                  
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                 A        AAA AAAAA AAAAAAA  AAA            AAA      AA                       
                                                                                                                                                            A  AAAA   AAAAA   AA                                              
                                                                                                                                                             A   AA    AAA    AA                                              
                                                    A                 A                                                                                                 A     AA                       AAAAAAAAAAAAA          
                 AAAAAA            AAAAAAA       AAAAAAA            AAAAAAA                                                                                                 AA     A        AAAA     AAA      AAAAAA          
                  AAAAAAAAA      AAAAAAA           AAAAAAAA      AAAAAAAA                                                                                                  AAAAAAAAAAAAAAAAAA AAAA AAA AAAAAAAAAAAAA          
                     AAAAAAA  AAAAAAA                 AAAAAAA  AAAAAAA                                                                                                    AAAAAAAAAAAAAAAAAAAAA AAAAA AAAAAAAAAAAAAA          
                        AA  AAAAAAA                      AA AAAAAAAA                                                                                                     AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                          AAAAAAA                          AAAAAA                                                                                                     AAAAAAAAAAAAAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAA          
                          AAAAAA                           AAAAA                                                                                                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAA          
                          AAAAAA                           AAAAA                                                                                             AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  AAAA AAAAAAAAAAAAAA          
                          AAAAAA                           AAAAA                                                                                        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AA AA AAAAAAAAAAAAAA          
                          AAAAAA                           AAAAA                                                                                AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAA          
                          AAAAAA                           AAAAA                                                                      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                          AAAAAA                           AAAAA                                                         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                          AAAAAA                           AAAAA                                                    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                                                                                                                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                                                                                                               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                                                                                                             AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                                                                                                           AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                        AAAAAAAAAAAAA              AAAAAAAAAAAA                                          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                     AAAAAAAAAAAAAAAAAAA       AAAAAAAAAAAAAAAAAAAA                                    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                   AAAAAAAAAAA  AAAAAAAAA    AAAAAAAAAAA   AAAAAAAA                                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                  AAAAAAA            A      AAAAAAAA           AA                                   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                 AAAAAAA                    AAAAAA                                                AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                 AAAAAA                    AAAAAAA                                               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                 AAAAAA                     AAAAAA                                             AAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAA          
                  AAAAAAA                   AAAAAAA                                              AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                  AAAAAAAAA       AAAAAA     AAAAAAAAA      AAAAAAA                                 AAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                    AAAAAAAAAAAAAAAAAAAAA      AAAAAAAAAAAAAAAAAAAA                                    AAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                       AAAAAAAAAAAAAAA           AAAAAAAAAAAAAAA                                         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                                                                                                          AAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                                                                                                          AA   AAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                       
                                                                                                                                                                                                                              "
var credit3 = "                                                                                                                                                                                                            
                                 A           A             AA        AA                            A                                                                                                               
                               A           AA             A  A      A  A                           AAA                               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                            AA AAA AAAAAAAA               A   AAAAAA   A                  AAAAAAAAA AAAA                             AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                           A    AA AAAAA AA                 A       AAA                  A  A  AA AA    A                            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                         AA     A AAAA   A                                   A           AA  AAAA  A     A                           AAAAAAAAAAAAAA  AAAAAAA   AAAAAAAAAAAAAAAAAAA   AA    AAAAAAAAAAA             
                        AA       AAAAAAAA      AA         A                  A              AAAAAA        AA                         AAAAAAAAA                     AAAAAAAAAAAAAAA   AAAAA  AAAAAAAAAA             
                       A               A       AA         A                  A                              A                        AAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAA                       AAAAAAA             
                      A               AA      AAA         A                  AA                              A                       AAAAAAAAAAA                  AAAAAAAAAAAAAAA      AAAAAAAAAAAAAAA             
                     A                A       AAA                            AAA   A                          A                      AAAAAAAA                        AAAAAAAAAAA        AAAAAAAAAAAAAA             
                    AA               AAAA     AAA          A                 AAA   AA                    A    AA                     AAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAA   A   AA   AAAAAAAAAAAA             
                   AA     A          A AA    AAAA          AA                AAAA  AAA                   AA    AA                    AAAAAAAAA                      AAAAAAA    AAA   AAAA   AAAAAAAAAA             
                   A     A           A AA    AA A           A                A  A  AAAA   A               A     A                    AAAAAAAAAAAAAAAA   A   AAAAAAAAAAAA     AAAAA   AAAAAA     AAAAAA             
                  A     AA           AAAAA   A  AA           A            A AA  AA AAAA   A               AA    AA                   AAAAAAAAAAA      AAAAA       AAAAAAA AAAAAAAA   AAAAAAAAAAAAAAAAA             
                 AA     A            AAA A   A  AA  A         A          AA A   AA AA AA  AA               A     A                   AAAAAAAAA   AAAAAAAAAAAAAAA    AAAAAAAAAAAAAA   AAAAAAAAAAAAAAAAA             
                 A     AA            AAA AA  A   AA A         AA         AA A    A A   A  AA               A     AA                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                AA     AA            AAA  A  A    A AA       A  A        AAAAAAAAAAAAAAAAAAA               A      A                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA             
                A      A             AAAAAAAAAAAAAAA AA       A  A       AAAA    AA     A AA               AA     A                                                                                                
               AA   A  A             AA    AAAA    AA AA A      A A     A AA     AA     AAAAA   A          AA     AA                                                                                               
               AA  AA  A         A   AA     AAAA    AAAAAAA     AAAAA   AAAAAAAAA        AA A  AA          AA      AA                                                                                              
               A  AAA  AA        A   AA       AA  AAAAAAAAAAA   AAA AAAA AA              A  AA A         A AA      AA                               AAAAAAA         AAAAAAA   AAAAAA          AAAAAAA              
               A AAA   A A        A   A                 A     AA       AA     AAAAAAAAAAAAAAAAAA         A AA       AA                               AAAAAAA       AAAAAAA    AAAAAA          AAAAAAA              
                AA A   AA AA       A  AAAAAAAAAAAAAAAAAAA                 AAAAAAAAAAAAA  AAAAAA        AAA AA       AA                                 AAAAAAA   AAAAAAA      AAAAAA          AAAAAAA              
               AA AA   AA AAAA      AAAAAAAA  AAAAAAAAAAAAAA             AAAAAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                 AAAAAAAAAAAAAAA       AAAAAA          AAAAAAA              
               A  AA   AAAAAAAAA AAAAA AAAA   AAAAAAAAAAA                   AAAAAAAAAA  AAA AAAAAAAAAAAAAAAAAAAAAAAAAAA                                  AAAAAAAAAAAA         AAAAAA          AAAAAAA              
                 AAAAAAAAAAAAAAAAAAAAAAAA AAA   AAAAAAAA                      AAAAAAA A    AAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                   AAAAAAAAA          AAAAAA          AAAAAAA              
                 AAAAAAAAAAAAAAAAAAAAAAAAA      AAAAAAA                                    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                   AAAAAAA           AAAAAA          AAAAAAA              
                AAAAAAAAAAAAAAAAAAAAAAAAAAA                                              AAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAA                                  AAAAAAA           AAAAAAA         AAAAAAA              
                AAAAAAAAAAAAAAAAAAAAAAAAAAAA                                            AAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                  AAAAAAA            AAAAAAAAA   AAAAAAAAA               
               AAAAAAAAAAAAAAAAAAAAAAAAAA AAAA                                               A  AAAAAAAAAAAA  AAAA AAAAAAAA                                 AAAAAAA             AAAAAAAAAAAAAAAAAA                 
               AAAAAAAAAAAA AAAAAAAAAAAAAA     AA                                          AAAAAAAAAAAAAAAAA    AA     AAAAAA                               AAAAAAA                AAAAAAAAAAAA                    
               AAA   AAAA   AAAAAAAAAAAAAAA                       AA                       AAAAAAAAAAAAAAAAA      A                                                                                                
                   AA       AAAAAAAAAAAAAAAAA                                            AAAAAAAAAAAAAAAAAAA                                                                                                       
                            AA AAAAAAAAAAAAAAA                                          AAAAAAAAAAAAAAAAAAAA                                                                                                       
                             A  AAAAAAAAAAAAAAAAA                                     AAAAAAAAAAAAAAAAAAAA A                    AAAAAA                    AAAAAAAA           AAAAAAA          AAAAAA               
                             A   AAAAAAAAAAAAAAAAAA                                 AAAAAAAAAAAAAAAAAA AAA A                    AAAAAA                   AAAAAAAAA           AAAAAAAAA        AAAAAA               
                              A  AAA AAAAAAAAAAAAAAAAAA                          AAAAAAAAAAAAAAAAAAA    AA A                    AAAAAA                  AAAAAAAAAAAA         AAAAAAAAAAA      AAAAAA               
                                 AA  AAAAAAAAAAAAAAAAAAAAA                   AAA  AAAAAAAAAAAAAAAAAA     A                      AAAAAA                 AAAAAAAAAAAAAA        AAAAAAAAAAAAA    AAAAAA               
                                AA    AAAAAAAAAAAAAAAA    AAAA            AAA     AAAAAAAAAA AAAA AA                            AAAAAA                AAAAAA   AAAAAAA       AAAAAA AAAAAAAA  AAAAAA               
                               A       A AAAA AAAAA  AA         AAA  AAA         AAA  AAAAA  AAA   AA                           AAAAAA               AAAAAAAAAAAAAAAAAA      AAAAAA   AAAAAAAAAAAAAA               
                                        A  AAA AAAA  AA                           A    AA     A                                 AAAAAA              AAAAAAAAAAAAAAAAAAAA     AAAAAA     AAAAAAAAAAAA               
                                                AA   AA                 AAAAAAAAAAAAA                                           AAAAAA             AAAAAAAAAAAAAAAAAAAAAA    AAAAAA       AAAAAAAAAA               
                                                   AAA          AAA   AAA AAAAAAAAAAAA                                          AAAAAAAAAAAAAAAA  AAAAAA           AAAAAAA   AAAAAA         AAAAAAAA               
                                                  AAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAA                                         AAAAAAAAAAAAAAAA AAAAAA             AAAAAAA  AAAAAA           AAAAAA               
                                                  AAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAA                                                                                                                           
                                              AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                                       
                                         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                                                                                                               

                                                                                                                                                                                                                   "

var credit4 = "       
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                   AAAA                                                                                                                                    
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                  AA AA                                             AA                                                                                     
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                 AA  AA                                             AA                                     AAA                               A             
            AAAAAAAAAAAAAA   AAAAAAA    AAAAAAAAAAAAAAAAAAA    A     AAAAAAAAAAA                AAA  A                                             AAAA              AA                     AA                               AAA           
            AAAAAAAAA                       AAAAAAAAAAAAAAA    AAAA   AAAAAAAAAA        AAAA    AA  AA   A      A                          A       AAAAA             AAAAAAA                AAA                             AAAAA          
            AAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAAAAAA      AAAA AAAAAAAAAAA        AAAA   AA   AA  AA      A                          A       AAAAA      AA     AAAAAAAA                AA                               AAA          
            AAAAAAAAAAA                    AAAAAA                        AAAAAAA        AAAAA AA    AA  AA      AA                        AA      AAAAAA      AA     AAAAAAAAA      A        AAA    A                         AAA          
            AAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAAAAA        AAAAAAAAAAAAAAA        AAAAAAA     AA  AA      AAA                       AAA     AAA  AA    AAAA     A AAAAAA      A        AAA    A                          AA          
            AAAAAAAA                         AAAAAAAAAAA           AAAAAAAAAAAAA        AAAAAAA     AAAAAAA AAAAAAA                   AAA AAAA   AAAA  AAA   AAAA     A  AAAAAA     AA      AAAAA   AA A                        A          
            AAAAAAAAAAAAAAAAAA    AAAAAAAAAAAAAAAAAAA     A    AA    AAAAAAAAAAA        AAAAAA      AAAAAAAAAAAAAAAA                 AAAAAAAAAAAAAAAA  AAA  AAAAAAA A AA  AAAAAA   AAA     AAAAAA   AAAA     A                             
            AAAAAAAAA                        AAAAAA     AAA    AAAA     AAAAAAAA        AAAAAAA     AAAAAAAAAAAAAAAAA               AAAAAAAAAAAAAAAAA   AA AAAAAAAAAAAAA  AAAAAAAAAAAAA   AAAAAAAA  AAAAAAA   A                            
            AAAAAAAAAAAAAAA     AA    AAAAAAAAAA     AAAAAA    AAAAAA    AAAAAAA        AAAAA    AAAAAAAAAAAAAAAAAAAAA  AA AAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAA  AAAAAAAA   AAAAAAAAAAAA   AAAAAAAA  AAAAAAAA  AA                           
            AAAAAAAA         AAAAAAA         AAAAAAAAAAAAAA    AAAAAAAAAAAAAAAAA        AAAA        AAAAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAAAA    AAAAAA  AAAAAAAA    AAAAAAAAAAA   AAAAAAAAA AAAAAAAAA AA                           
            AAAAAAAAA AAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAAAA        AAAA        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA    AAAAAA  AAAAAAA     AAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAAAAA                          
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA        AAA         AAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA     AAAAAAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAA       A                 
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA        AAA         AAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA      AAAA     AAAAAAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAA     AAAA  AAAA          
                                                                                        AAA          AA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA      AAA      AAAAA       AAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAA          
                                                                                        AAA          AA  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       AAA      AAAAA        AAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAA          
                                                                                        AAA          AA  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       AAAA       AAA         AAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                      AAA           AAAA                                                AAAAAAAAAA    AA  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       AAA        AAA          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                     AAAAA         AAAAA                                                AAAAAAA  AAAAAAAA  AAAAAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAA       AAA        AAA          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                AAAAAAAAAAAAAA AAAAAAAAAAAAAAA     AAAAAAAAAAAAAAAAAAAAAAAAA            AAA    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAA        AA         AAA          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                   AAAAAAAAA      AAAAAAAA                                              A A    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAA        A     AAAAAAAAAA         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                 AAAAAAAAAAAAA AAAAAAAAAAAAAA                                           AAAA   AAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAA  AAAAAAAAAAAAAA      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                AAAA  AAA   A  AAA  AAAA  AAAA                                          AAAA   AAAAAAAAAA  AAAAAA AAAAAAAAAAAAAAA   AAAAAAAAAAAAA   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA     AAAAAAAAAAAAAAAA          
                      AAA  AAAAA    AAA              AAAAAAAAAAAAAAAAAAAA               AAA    AAAAAAA AA  AAAAAAA    AAA  AAAAAAA   AAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       AAAAAAAAAAAAAAA          
                       AAAAAAAAAAAAAAAAAAA           AAAAAAAAAAAAAAAAAAAA                AA     AAAAAAA AAAAAAAAA                      AAAAAAAAAAA    AAAAAAAAAAA  AA AAAAAAA     AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAA          
                  AAAAAAAAAAAAAAAAAAAAAAAA                                                 A     AA    AAAAAAAAAA                                     AAAAAAAA AA  AA AAAAAAA     AAAAAAAAAAAAAAAAAAAAAAAAA    AA   AAAAAAAAAAAAA          
                   AAAA AAAAA     AAAAAA                                                A   AA    AAA         AA                                       AAA AAAAA AA  AAA  AA     AAAAAAAAAAAAAAAAAAAAAAAAAAA         AAAAAAAAAAAA          
                          AAAAAAAAAAA                                                   AA     AAA  AAAA    AAA                                        AAA    AAAAAAAA   AA     AAAAAAAAAAAAAAAAAAAAAAAAA  AAA       AAAAAAAAAAAA          
                    AAAAAAAAAAAAAA               AAAAAAAAAAAAAAAAAAAAAAAAAAAAA          AA        AAAAAAAAAA                                             AA            AAA    AAAAAAAAAAAAAAAAAAAAAAAAAAA        A   AAAAAAAAAAAA          
                  AAAAAAAAAA                      AAAAAAAAAAAAAAAAAAAAAAAAAAA            AA                                                                 AAA     AAA    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AA  AA   AAAAAAAAAAAA          
                                                                                          AA                                                             AAAAAAAAAAAAAAAAAA     AAAAAAAAAAAAAAAAAAAAAAAAA   AAAAA   AAAAAAAAAAAAA          
                                                                                           AA                                                                                   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   AAAAAAAAAAAAAA          
                                                                                                                                                                               AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA    AAAAAAAAAAAAAAA          
                           AAAAA                                                        AA                                                                                    AAAAAAAAAAAAAAAAAAAAAAAAAAAA      AAAAAAAAAAAAAAAAA          
                           AAAAA                 AAAAA                                  AAA                                                                                   AAAAAAAAAAAAAAAAAAAAAAAAA        AAAAAAAAAAAAAAAAAA          
                           AAAAA                AAAAAA                                  AAAA                                                                                AAAAAAAAAAAAAAAAAAAAAAAAAAA      AAAAAAAAAAAAAAAAAAAA          
                  AAAA     AAAAA    AAAA          AAA                                   AAAAAA                                                                            AAAAAAAAAAAAAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAA          
                  AAAAA    AAAAA    AAAAA       AAAAAA                                  AAA  AAA                                                                         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                 AAAAA     AAAAA     AAAAA      AAAAAA                                  AAA                          A                                                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                AAAAA      AAAAA      AAAAA     AAAAAA                                  AAAA                         A                                              AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
               AAAAA       AAAAA       AAAAA    AAAAAA                                  AAAAA                                                                     AAAAAAAAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
              AAAAA        AAAAA        AAAAA   AAAAAA                                  AAAAAAA                                                               AAAAAAAAAAA      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
              AAAA         AAAAA         AAAA   AAAAAA                                  AAAAAAAAA                                                         AAAAAA              AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          
                           AAAAA                AAAAAA                                  AAAAAAAAAAA                                                                         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA    AAA          
                     AAAAAAAAAAA                AAAAAA                                  AAAAAAAAAAAA                AAAA                                                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA      AA          
                      AAAAAAAAA                                                         AA  AAAAAAAAAAA                        AAAAAAA                                AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       A          
                                                                                        A   AAAAAAAAAAAAA                                                          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA                  
                                                                                                                                                                                                                                           
                                                                                                    
                                                                                                                                                                                                                                           "                                                                                                                                                                                                                   
