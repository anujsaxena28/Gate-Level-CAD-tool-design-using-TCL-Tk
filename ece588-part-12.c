#include<stdio.h>

int getmaxcol(int);
int getmincol(int);
int overall_max;

int num;
int original[15][15],a[15][15],tran[15][15];	/*	original[10][10]:	record of input adjacency matrix
												
													a[10][10]:			adjacency matrix for arrival time calculation
													
													tran[10][10]:		new transformed adjacency matrix used for 
																		required time calculation
																		(whether use it or not depends on your algorithm)
												 */


int main(int argc, char **argv)
 {
     int n=14,i,j,max,min,max_arrival_time,out[15],arrival[15],required[15],slack[15];
     char nodes[] = {'G','I','A','B','D','H','K','J','C','L','E','M','F'};
	
	 num=n;
     //reading the adjacency matrix from the file inputs.txt
	 FILE *fp; 
	 fp = fopen("inputs.txt","r");
	 
	 
	 
	 for(i=0;i<n;i++)
	 {
		for(j=0;j<n;j+=1)
		{
				fscanf(fp,"%d",&original[i][j]);
				a[i][j]=original[i][j];
	    }
	 }
	 
	 fclose(fp); 
	 
	 
	 //printf("\nEnter the number of nodes:");
     //scanf("%d",&n);
     
     //printf("\nEnter the matrix: \n");
     //for(i=0;i<n;i++)
      //{
        // for(j=0;j<n;j++)
         //{
           // scanf("%d",&original[i][j]);	/* Input adjacency matrix here */
            //a[i][j]=original[i][j];
			//tran[i][j] = original[i][j];
         //}  
      //}
	 
     
     printf("\nInput matrix is:\n"); /* Print out the input matrix for your double check */
     
     for(i=0;i<n;i++)
       {
        for(j=0;j<n;j++)
         printf("%3d",a[i][j]);
         
         printf("\n");
       }
     
	// Find the last nodes
	for(i=0; i<n; i++)
		out[i]=0;
	
	for(i=0; i<n; i++)
	{
		for(j=0; j<n; j++)
		{
			if(a[i][j] > 0)
				break;
			
			if(j == n-1)
				out[i]=1;  
		}
	}
	
	for(i=0; i<n; i++)
		printf("\n %d ", out[i]);
/*=================== Arrival Time Calculation ==================*/

     printf("\n\nCalculate the arrival time: \n\n");
     overall_max=0;
     for(i=0;i<n;i++)
      { 
        max=getmaxcol(i);
        for(j=0;j<n;j++)
         if(a[i][j] !=0)
           a[i][j]=(a[i][j]+max);
	    if(overall_max<max)
			overall_max=max;
      }
      
     
/*=================== Required Time and Slack Calculation to be filled ==================*/

/* 1. Implement required time calculation for each node */

/* 2. You can follow the way we implemented to calculate the arrival time or you can implement by your own algorithm */

/* 3. You may need change the adjacency matrix to calculate the required time */

/* 4. Calculate the slack time using the arrival and required time */

	
	/* Find the transpose of the original adjacency matrix */
	
	for(i=1; i<n; i++)
	{
		for(j=1; j<n; j++)
		{
			if(original[j][i] != 0)
				tran[i-1][j-1] = original[j][i];
			else
				tran[i-1][j-1] = 10000;
		}
	}
	
	// assign the max arrival time as the required time of the last nodes  
	    printf("max =%d", max);
		for(j=0; j<n-1; j++)
		{
			if(out[j+1] != 1)
				tran[n-1][j] = 10000; 
			
			else 
				tran[n-1][j] = overall_max; 
			
			tran[j][n-1] = 10000;
		}

	tran[n-1][n-1] = 10000; 
	
	// printing tran matrix
	printf("The tran matrix for calculating required time: \n");
	for (i=0; i<n; i++)
	{   
		printf("\n");
		for (j=0; j<n; j++)
		{
			printf("%3d\t", tran[i][j]);
		}
		printf("\n");
	}
	
	printf("\n\nCalculate the required time: ");
	
	for(i=n-2; i>=0; i--)
	{
		min = getmincol(i);
		for(j=n-1; j>=0; j--)
		{
			if(tran[i][j] != 10000)
				tran[i][j] = min - tran[i][j]; 
		}
	}
	printf("\n Required Time matrix: \n");
	
	for (i=0; i<n; i++)
	{   
		printf("\n");
		for (j=0; j<n; j++)
		{
			printf("%3d\t", tran[i][j]);
		}
		printf("\n");
	}




/*=================== Printing the Results ========================*/

/* 5. The arrival time is already printed by this program. You have to print the required time and slack time similarly*/

    max=0;
    min=10000;
    
    for(i=1;i<n;i++)
     {
         for(j=0;j<n;j++)
         {
            if(a[j][i] > max)
            max=a[j][i];
         }
         
         arrival[i-1]=max;
         max=0;
     }
	 
	 for(i=0; i<n-1; i++)
	 {
		 for(j=0; j<n; j++)
		 {
			 if(tran[j][i] < min)
				 min = tran[j][i];
		 }
		 required[i] = min;
		 min = 10000; 
	 }
	 
	 //Slack time calculation 
	 
	 for(i=0; i<n-1; i++)
	 {
		 slack[i] = required[i] - arrival[i]; 
	 }
     
	 fp = fopen("outputs.txt","w"); 
     fprintf(fp, "\n\nFinal Results:\nNodes  \t   Arrival   \t  Required   \t  Slack\n");
     for(i=0;i<n-1;i++)
     {
       fprintf(fp, "  %c\t\t%d\t\t%d\t\t%d\n",nodes[i],arrival[i],required[i],slack[i]);
     }
	 fclose(fp);
 }
 


 /*=============================== Sub-functions ===============================*/
 /* Get the maximum value from a matrix column with the specified column number */
 int getmaxcol(int colnum)
  {
    int i,max;
    
     max=a[0][colnum];
    for(i=1;i<num;i++)
          if(a[i][colnum] > max)
          max = a[i][colnum];
          printf("max =%d", max);
     return max;
  }
  
  //get minimum value from a matrix column with specified column number
 int getmincol(int colnum)
  {
    int i,min;
    
    min=tran[0][colnum];
    for(i=1;i<num;i++)
          if(tran[i][colnum] < min)
          min = tran[i][colnum];
        
     return min;
  }
  
 

  
