#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

package require Tk

set slackParams ""
set slacks() ""

 # drawgraph.tcl --
 #    Script to draw graphs (represented as edgelist) in a canvas
 #

 # DrawGraph --
 #    Namespace for the commands
 #
 namespace eval ::DrawGraph:: {
    variable draw_vertex  "DrawVertex"
    variable draw_edge    "DrawEdge"
    variable curved       0
    variable directed     0
 }

 # DrawVertex --
 #    Default vertex drawing routine
 # Arguments:
 #    canvas    Canvas to draw on
 #    xv        X coordinate
 #    yv        Y coordinate
 #    name      Name of the vertex
 
 # Output:
 #    Filled circle drawn at vertex
 #
 proc ::DrawGraph::DrawVertex { canvas xv yv name } {
    $canvas create oval [expr {$xv-18}] [expr {$yv-18}] \
                        [expr {$xv+18}] [expr {$yv+18}] 
		
  $canvas create text $xv $yv -text $name -tag $name
  $canvas bind $name <1> "enterSlack $name"
 }

# DrawEdge --
 #    Default edge drawing routine
 # Arguments:
 #    canvas    Canvas to draw on
 #    xb        X coordinate begin
 #    yb        Y coordinate begin
 #    xe        X coordinate end
 #    ye        Y coordinate end
 #    curved    Draw a curved edge or not
 #    directed  Draw an arrow head or not
 #    attrib    Attribute of the vertex

 # Output:
 #    Line from the beginning to the end
 #
 
 proc ::DrawGraph::DrawEdge { canvas xb yb xe ye curved directed attrib } {
    if { $directed } {
       set arrowtype last
    } else {
       set arrowtype none
    }

    set dx [expr {$xe-$xb}]
    set dy [expr {$ye-$yb}]
    if { ! $curved } {
       set xc [expr {$xb+0.5*$dx}]
       set yc [expr {$yb+0.5*$dy}]
    } else {
       set xc [expr {$xb+0.5*$dx-0.1*$dy}]
       set yc [expr {$yb+0.5*$dy+0.1*$dx}]
    }
    $canvas create line $xb $yb $xc $yc $xe $ye -fill black \
       -arrow $arrowtype -smooth $curved
 }

   # This function will draw the GUI
   
   proc main {} {
  
        set canvasHeight 800
        set canvasWidth 1200
        
        set xaxis 100
        set yaxis [expr $canvasHeight/2]
        
        canvas .c1 -background gray -relief sunken -width $canvasWidth -height $canvasHeight
        pack .c1
        
        set name "FindSlacks"
        .c1 create text 50 20 -text $name -tag $name
        .c1 bind $name <1> "findSlack $name"
        
        # Draw PI node here
        
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-1100] [expr (($canvasHeight)/4)] "PI"
        
        # Draw the First three input nodes here. i.e., G, I AND A
        
        set yincr [expr ($canvasHeight/8)];
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-1000] [expr ($canvasHeight/8)] "G"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-1080] [expr (($canvasHeight)/4)] [expr ($canvasWidth)-1020] [expr ($canvasHeight/8)] 0 1 0
        
        set yincr [expr ($canvasHeight/4)]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-1000] [expr ($canvasHeight/4)] "I"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-1080] [expr (($canvasHeight)/4)] [expr ($canvasWidth)-1020] [expr ($canvasHeight/4)] 0 1 0
        
        set yincr [expr ($canvasHeight)/2.5]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-1000] [expr ($canvasHeight)/2.5] "A"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-1080] [expr (($canvasHeight)/4)] [expr ($canvasWidth)-1020] [expr ($canvasHeight)/2.5] 0 1 0
        
        # Draw the next two nodes B AND D
        
        set yincr [expr ($canvasHeight)/2]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-900] [expr ($canvasHeight)/2] "B"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-980] [expr ($canvasHeight)/2.5] [expr ($canvasWidth)-920] [expr ($canvasHeight)/2] 0 1 0
        
        set yincr [expr ($canvasHeight)/1.5]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-900] [expr ($canvasHeight)/1.5] "D"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-980] [expr ($canvasHeight)/2.5] [expr ($canvasWidth)-920] [expr ($canvasHeight)/1.5] 0 1 0
        
        # Draw the nodes H AND K
        
        set yincr [expr ($canvasHeight/8)];
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-800] [expr ($canvasHeight/8)] "H"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-980] [expr ($canvasHeight/8)] [expr ($canvasWidth)-820] [expr ($canvasHeight/8)] 0 1 0
        
        set yincr [expr ($canvasHeight)/2.5]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-800] [expr ($canvasHeight)/2.5] "K"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-980] [expr ($canvasHeight/4)] [expr ($canvasWidth)-820] [expr ($canvasHeight)/2.5] 0 1 0
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-980] [expr ($canvasHeight)/2.5] [expr ($canvasWidth)-820] [expr ($canvasHeight)/2.5] 0 1 0
        
        # Draw the nodes J AND C
        
        set yincr [expr ($canvasHeight/2)];
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-700] [expr ($canvasHeight/2)] "C"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-880] [expr ($canvasHeight)/2] [expr ($canvasWidth)-720] [expr ($canvasHeight/2)] 0 1 0
        
        set yincr [expr ($canvasHeight)/4]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-700] [expr ($canvasHeight/4)] "J"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-780] [expr ($canvasHeight/8)] [expr ($canvasWidth)-720] [expr ($canvasHeight/4)] 0 1 0
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-780] [expr ($canvasHeight)/2.5] [expr ($canvasWidth)-720] [expr ($canvasHeight/4)] 0 1 0
        
        # Draw the nodes L AND E
        
        set yincr [expr ($canvasHeight)/2.5]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-600] [expr ($canvasHeight)/2.5] "L"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-780] [expr ($canvasHeight)/2.5] [expr ($canvasWidth)-620] [expr ($canvasHeight)/2.5] 0 1 0
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-680] [expr ($canvasHeight/2)] [expr ($canvasWidth)-620] [expr ($canvasHeight)/2.5] 0 1 0
        
        set yincr [expr ($canvasHeight)/1.5]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-600] [expr ($canvasHeight)/1.5] "E"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-880] [expr ($canvasHeight)/1.5] [expr ($canvasWidth)-620] [expr ($canvasHeight)/1.5] 0 1 0
        
        # Draw the nodes M AND F
        
        set yincr [expr ($canvasHeight)/2]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-500] [expr ($canvasHeight)/2] "F"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-580] [expr ($canvasHeight)/1.5] [expr ($canvasWidth)-520] [expr ($canvasHeight)/2] 0 1 0
        
        set yincr [expr ($canvasHeight)/4]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-500] [expr ($canvasHeight)/4] "M"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-680] [expr ($canvasHeight/4)] [expr ($canvasWidth)-520] [expr ($canvasHeight)/4] 0 1 0
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-580] [expr ($canvasHeight)/2.5] [expr ($canvasWidth)-520] [expr ($canvasHeight)/4] 0 1 0
        
        # Draw the node PO
        
        set yincr [expr ($canvasHeight)/4]
        ::DrawGraph::DrawVertex .c1 [expr ($canvasWidth)-400] [expr ($canvasHeight)/4] "PO"
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-480] [expr ($canvasHeight)/4] [expr ($canvasWidth)-420] [expr ($canvasHeight)/4] 0 1 0
        ::DrawGraph::DrawEdge .c1 [expr ($canvasWidth)-480] [expr ($canvasHeight)/2] [expr ($canvasWidth)-420] [expr ($canvasHeight)/4] 0 1 0
  }
  
  # Calls main function
  
  set xyz [main]
  
 # This function will accept the input when each node is clicked
 
 proc enterSlack { param } {
      set canvasWidth 30
      set canvasHeight 20
      set var 0
      global slackParams
      
      set slackParams $param
      
      toplevel .t3
        
      canvas .t3.c1 -bg gray -width $canvasWidth -height $canvasHeight
      grid .t3.c1
      label .t3.c1.l -text "Enter:"
      grid .t3.c1.l
      entry .t3.c1.e -width 20 -relief sunken -bd 2 -textvariable name
      grid .t3.c1.e
      focus .t3.c1.e
      button .t3.c1.b -text Ok -command {readInputs $name; set name ""}
      grid .t3.c1.b
   }
 
   # This function will store the inputs received from enterSlack function into an array called "slacks"
   
   proc readInputs { name } {
      global slackParams
      global slacks
      
      set slacks($slackParams) $name
      destroy .t3
   }  
      

#=================== To be filled by Students ==================


   proc findSlack { name } {
      
       global slackParams
       global slacks

       set canvasHeight 800
       set canvasWidth 1200
       
       # Note: This function works only if you have read all the inputs by clicking each node in the graph
       
       
	   
       
       # Step 1: Add TCL code here so that the inputs go into the file "inputs.txt" in the form of a matrix
	         # Read the inputs from the "slacks" array that was recorded by the readInputs function
       	    	 # and write these inputs to the file "inputs.txt" (which is given below) in the form of a
	         # matrix that the C program can read.
	         # For example slacks("G") would give the delay for node "G"
       #set adj {{0 2 13 6 0 0 0 0 0 0 0 0 0 0} {0 0 0 0 0 0 10 0 0 0 0 0 0 0} {0 0 0 0 0 0 0 2 0 0 0 0 0 0} {0 0 0 0 4 2 0 2 0 0 0 0 0 0} {0 0 0 0 0 0 0 0 0 7 0 0 0 0} {0 0 0 0 0 0 0 0 0 0 0 4 0 0} {0 0 0 0 0 0 0 0 6 0 0 0 0 0} {0 0 0 0 0 0 0 0 6 0 6 0 0 0} {0 0 0 0 0 0 0 0 0 0 0 0 6 0} {0 0 0 0 0 0 0 0 0 0 6 0 0 0} {0 0 0 0 0 0 0 0 0 0 0 0 6 0} {0 0 0 0 0 0 0 0 0 0 0 0 0 10} {0 0 0 0 0 0 0 0 0 0 0 0 0 0} {0 0 0 0 0 0 0 0 0 0 0 0 0 0}}
       
       set slackfile [open "inputs.txt" w]
	   
	puts $slackfile "0\t$slacks(G)\t$slacks(I)\t$slacks(A)\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t$slacks(H)\t0\t0\t0\t0\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t$slacks(K)\t0\t0\t0\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t$slacks(B)\t$slacks(D)\t0\t$slacks(K)\t0\t0\t0\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t$slacks(C)\t0\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t$slacks(E)\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t$slacks(J)\t0\t0\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t$slacks(J)\t0\t$slacks(L)\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t$slacks(M)\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t$slacks(L)\t0\t0\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t$slacks(M)\t0\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t$slacks(F)\t"
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t"       
	puts $slackfile "0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t"
	   #foreach x $adj {
		#		puts $slackfile $x
	   #}
       close $slackfile
       
       # Step 2: Before proceeding to the further step, Modify your completed C program in part-1 such that
		 # it can read the adjacency matrix from the file "inputs.txt" rather than the user input.
		 # Modify your completed C program in part-1 such that it writes the arrival time, required time and
	         # slack to a file "outputs.txt"
              
       # Step 3: Add TCL code below to Compile and Run the C program by using the Tcl command 'exec'
       
	   #compiling the C program
	   exec gcc ece588-part-12.c -o part2.exe
	   #executing the executable generated by the 
	   exec part2.exe
	   
       # Step 4: Add TCL commands below such that it reads the "outputs.txt" and displays them on the Graphical User Interface
       set slackfile [open "outputs.txt" r]
	   
	   #read the contents of the output file "outputs.txt"
	   set file_data [read $slackfile]
	   .c1 create text [expr ($canvasWidth)-200] [expr ($canvasHeight)/2] -text $file_data
	    
	   close $slackfile
   }    
 
