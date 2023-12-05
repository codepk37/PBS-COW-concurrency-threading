
#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<pthread.h>
#include <string.h>
#include <semaphore.h>

#include <stdbool.h>
#define MAX_SIZE 100
typedef struct {
    char key[100];
    int value;
} KeyValuePair;

typedef struct {
    KeyValuePair data[MAX_SIZE];
    int size;
} Map;
Map map; // Declare map as a global variable
void initializeMap() {
    map.size = 0;
}
bool insert(char key[100], int value) {
    if (map.size < MAX_SIZE) {
        strcpy(map.data[map.size].key ,key);
        map.data[map.size].value = value;
        map.size++;
        return true;
    }
    return false;
} //insert("coco", 4);
int find(const char key[100]) {
    for (int i = 0; i < map.size; i++) {
        if (strcmp(map.data[i].key, key) == 0) {
            return map.data[i].value;
        }
    }
    return -1;
}//find("coco");

pthread_mutex_t mutex_s;pthread_cond_t cond_sec;
int sec=-1;
void *counter(){
    while(1){
    // printf("time: %d \n",sec);
    sec++;
    sleep(1);
    pthread_cond_broadcast(&cond_sec);
    }
}

int min(int a,int b){
    if(a<b)
        return a;
    else{
        return b;
    }
}

typedef struct c{
    int i;
    char cof[100];
    int t_arr_i;
    int tol_i;
}customer;

customer *arr; // custom arr[n];  GLOBAL

sem_t semaphore;
pthread_cond_t cond_swapn;
pthread_mutex_t mutex,mutex2;
int b,k,n; //barber , cofee, customer
int ind=0;
int spawned;//b

int *barber;
int wasted_cofee=0;
double waiting_time=0;
sem_t binary_sem;

int* ex; //ex[] ,exited_printing()

void * customer_handler(void * arg){
    int cur_ind= *(int*)arg;
    free(arg);

    pthread_mutex_lock(&mutex);
    // while(cur_ind<spawned) make it
    while( cur_ind>=spawned ){  //check index
        pthread_cond_wait(&cond_swapn, &mutex);
    }
    pthread_mutex_unlock(&mutex);

    //till here threads given barber index wise
    sem_wait(&semaphore);
    // printf("customer ind : %d",cur_ind);
    //task
    // printf("index :%d\n",arr[cur_ind].i);
    // make_cofee_for_i(ind);
    // printf(" %d   %d  \n",arr[cur_ind].t_arr_i,sec);



    while(arr[cur_ind].t_arr_i>sec){  //wait till arrival,even if barber is assigned (coz sequential)
        pthread_mutex_lock(&mutex_s);
        pthread_cond_wait(&cond_sec, &mutex_s);
        pthread_mutex_unlock(&mutex_s);
    }
    int arrival=sec; //time when got barber (coz may be late than t_arr_i )

    /*  MADE NEW 'N' THREADS FOR PRINTING INDEPENTELY SHOULD SEC
    printf("Customer %d arrives at %d seconds(s)\n",arr[cur_ind].i,arr[cur_ind].t_arr_i);
    printf("Customer %d orders a %s\n",arr[cur_ind].i,arr[cur_ind].cof);
    */

    /*
    if(arrival>= arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i +1 ){ //ignore if needed ~+asked in doubt
        printf(" U turn from barber of customer:%d  i.e. left before barber attention\n",arr[cur_ind].i);
        //relaese all lock ,execute end part
        //arrived and returened as unattened 
         pthread_mutex_lock(&mutex);
        spawned++;
        ind++;
        // barber[got]=0;
        pthread_mutex_unlock(&mutex);
        
        sem_post(&semaphore);
        pthread_cond_broadcast(&cond_swapn );
        
        return  NULL;
    }
    */
    
    // usleep(900000); 
    int got=-1; //barber
    int flag=1;

    for(int i=0; flag;i=(i+1)%b){
        pthread_mutex_lock(&mutex2); //to avoid delay coz of mutex ->made mutex2
        if(barber[i]==0){
            barber[i]=1;
            got=i;
            flag=0;
        }
        pthread_mutex_unlock(&mutex2);
    }

    //got ->barber is assigned
      
    while(arrival+1>sec){  //~ sleep(1)   +1 sec
        pthread_mutex_lock(&mutex_s);
        pthread_cond_wait(&cond_sec, &mutex_s);
        pthread_mutex_unlock(&mutex_s);
    }
    pthread_mutex_lock(&mutex2);
    waiting_time+=min( (sec),arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i )-arr[cur_ind].t_arr_i;// waiting time
    pthread_mutex_unlock(&mutex2);
    int ret_flag=0,ret_sec=0; //at last sec of tol_i tolernace if exited ->1 
    if(ex[cur_ind]==1 || arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i +1==sec ){
        ret_flag=1;
        ret_sec=sec;
    }
    if(ret_flag){   //very imp check printf 
        // printf("Customer %d order removed from List at %d coz he left even before or at time of getting barrista\n", arr[cur_ind].i,sec);
        return NULL;//Q52,  -no cofee gets wasted + waiting time calc above before returning
    }
    printf("\033[1;36mBarista %d begins preparing the order of customer %d at %d second(s)\033[0m\n", got+1, arr[cur_ind].i, sec);
    // printf("Barista %d begins preparing the order of customer %d at %d second(s)\n",got+1,arr[cur_ind].i,sec);
    //arrival+1 sec 
    // pthread_mutex_lock(&mutex2);
    // waiting_time+=min( (sec),arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i )-arr[cur_ind].t_arr_i;// waiting time
    // pthread_mutex_unlock(&mutex2);

    int is_cofee;
    if(  (arrival+1)+  find(arr[cur_ind].cof)    <= arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i  ){
        //take cofee
        pthread_mutex_lock(&mutex_s);
        ex[cur_ind]=1;   //dont let exited_printng happen as we are gonna get cofee
        pthread_mutex_unlock(&mutex_s);

        is_cofee=1;
    }
    else{
        //gonna leave
        is_cofee=0;
    }

    if(is_cofee){
        // printf("is_cofee  :   %d   %d  \n",(arrival+1)+  find(arr[cur_ind].cof) ,sec);
        while((arrival+1)+  find(arr[cur_ind].cof) >sec){  //~ sleep(1)   +1 sec
            pthread_mutex_lock(&mutex_s);
            pthread_cond_wait(&cond_sec, &mutex_s);
            pthread_mutex_unlock(&mutex_s);
        }
        printf("\033[1;34mBarista %d completes the order of customer %d at %d second(s)\033[0m\n", got+1, arr[cur_ind].i, sec);
        printf("\033[1;32mCustomer %d leaves with their order at %d second(s)\033[0m\n", arr[cur_ind].i, sec);


    }
    else{

        ////    HERE---
        // while(arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i+1>sec){  
        //     pthread_mutex_lock(&mutex_s);
        //     pthread_cond_wait(&cond_sec, &mutex_s);
        //     pthread_mutex_unlock(&mutex_s);
        // }//make seperate thread and communicate 
        // printf("\033[1;31mCustomer %d leaves without their order at %d second(s)\033[0m\n", arr[cur_ind].i, sec);
        ////
        pthread_mutex_lock(&mutex_s);
        if(ex[cur_ind]==0){          //make seperate thread and communicate  
            ex[cur_ind]=1;     

            while(arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i+1>sec){  
                pthread_cond_wait(&cond_sec, &mutex_s);
            } 
            printf("\033[1;31mCustomer %d leaves without their order at %d second(s)\033[0m\n", arr[cur_ind].i, sec);

        }
        else{
            // printed before by ex[cur_ind], tolerence over even before getting barber
        }
        pthread_mutex_unlock(&mutex_s);


        while((arrival+1)+  find(arr[cur_ind].cof) >sec){  //still complete order
            pthread_mutex_lock(&mutex_s);
            pthread_cond_wait(&cond_sec, &mutex_s);
            pthread_mutex_unlock(&mutex_s);//
        }
        pthread_mutex_lock(&mutex);
        wasted_cofee+=1;
        pthread_mutex_unlock(&mutex);
        printf("\033[1;34mBarista %d completes the order of customer %d at %d second(s)\033[0m\n", got+1, arr[cur_ind].i, sec);
    }


    // int leave_at=  (barber took=arrival+1) +t_c ; //t_c->time to make cofee
    //     //taking cofee
        
    // int leave_withcofee_at = arrival+1+

    // //(stay even till t_arr_i + tol_i)
    // int leave_at=  t_arr_i + tol_i +1  ;//directly leave (stay even till t_arr_i + tol_i)
    //     //before


    
    sem_wait(&binary_sem);   //sem( , 0, 1) Just for namesake used binary semaphore to Mention it
   spawned++;
    ind++;
    barber[got]=0;
    sem_post(&binary_sem); //works as single mutex only
    
    
    sem_post(&semaphore);
    pthread_cond_broadcast(&cond_swapn );
    
    return  NULL;

}


void* exited_printing(void * arg){
    int cur_ind= *(int*)arg;
    free(arg);

    //ex[] mutex ,
    while(arr[cur_ind].t_arr_i+ arr[cur_ind].tol_i+1>sec){  
        pthread_mutex_lock(&mutex_s);
        pthread_cond_wait(&cond_sec, &mutex_s);
        pthread_mutex_unlock(&mutex_s);
    }//make seperate thread and communicate 
    //basically print exited
    //possible to leave even before barber is assigned
    pthread_mutex_lock(&mutex_s);
    if(ex[cur_ind]==0){
        printf("\033[1;31mCustomer %d leaves without their order at %d second(s)\033[0m\n", arr[cur_ind].i, sec);
        ex[cur_ind]=1;
        // printf("in exited\n");
    }
    pthread_mutex_unlock(&mutex_s);

}





// int arrival_ind=0;
int arrival_spwaned;
pthread_mutex_t arrival_mutex;
pthread_cond_t cond_arrival;
void* arrival_printing(void *arg){
    int cur_ind= *(int*)arg;
    free(arg);

    pthread_mutex_lock(&arrival_mutex);
    // while(cur_ind<spawned) make it
    while( cur_ind>=arrival_spwaned ){  //check index
        pthread_cond_wait(&cond_arrival, &arrival_mutex);
    }
    pthread_mutex_unlock(&arrival_mutex);
    //1 index only reach index wise

    while(arr[cur_ind].t_arr_i>sec){  //wait till arrival,and print at arrival_sec
        pthread_mutex_lock(&mutex_s);
        pthread_cond_wait(&cond_sec, &mutex_s);
        pthread_mutex_unlock(&mutex_s);
    }
        
    printf("\033[0;97mCustomer %d arrives at %d seconds(s)\033[0m\n",arr[cur_ind].i,arr[cur_ind].t_arr_i);
    printf("\033[1;33mCustomer %d orders a %s\033[0m\n",arr[cur_ind].i,arr[cur_ind].cof);


    pthread_mutex_lock(&arrival_mutex);
    arrival_spwaned++;
    pthread_mutex_unlock(&arrival_mutex);
    pthread_cond_broadcast(&cond_arrival );

    return NULL;
}


int main(){
    // int b,k,n;   barber , cofee, customer
    scanf("%d %d %d",&b, &k,&n);
    spawned=b;
    arrival_spwaned=1; //one at time
    //key :cofee -> value : t_c   time to make
    ex = (int*)malloc(n * sizeof(int)); //exited_printing
    for (int i = 0; i < n; i++) {
        ex[i]=0;
    }
    
    initializeMap();
    for(int i=0;i<k;i++){  //cofee : t_c time to make
        char val[100];int key;
        scanf("%s %d",val,&key);
        insert(val, key);
    }
    
    //int key =find("coco");

    // barber initialize 0
    barber=(int*)malloc(b* sizeof(int));
    for(int i=0;i<b;i++){
        barber[i]=0;
    }

    // custom arr[n];
    arr= (customer*)malloc(n* sizeof(customer)); //dynamically allcoated
    for(int i=0;i<n;i++){
        scanf("%d %s %d %d", &arr[i].i, arr[i].cof, &arr[i].t_arr_i, &arr[i].tol_i);
    }

    sem_init(&semaphore, 0, b);sem_init(&binary_sem, 0, 1);
    pthread_cond_init(&cond_swapn , NULL);pthread_cond_init(&cond_sec , NULL);pthread_cond_init(&cond_arrival , NULL);
    pthread_mutex_init(&mutex, NULL);pthread_mutex_init(&mutex2, NULL);pthread_mutex_init(&mutex_s, NULL);pthread_mutex_init(&arrival_mutex, NULL);

    pthread_t counter_sec;
    pthread_create(&counter_sec,NULL,&counter,NULL);

    pthread_t arrival[n];
    for(int i=0;i<n;i++){
        int *a=(int*)malloc(sizeof(int)); 
        *a=i;
        pthread_create(&arrival[i],NULL,&arrival_printing,a);
    }
   
    pthread_t th[n];
    for(int i=0;i<n;i++){
        int *a=(int*)malloc(sizeof(int)); 
        *a=i;
        pthread_create(&th[i],NULL,&customer_handler,a);
    }

    pthread_t exited[n];
    for(int i=0;i<n;i++){
        int *a=(int*)malloc(sizeof(int)); 
        *a=i;
        pthread_create(&exited[i],NULL,&exited_printing,a); //mutex ex[]
    }


    
    for(int i=0;i<n;i++){
        pthread_join(th[i],NULL); //customer
    }
    for(int i=0;i<n;i++){
        pthread_join(arrival[i],NULL);
    }
    // for(int i=0;i<n;i++){            //if customer leaves before barista, arrival still in waiting, ,,but if exiting handles in arrival by case -there is no need to wait(print abouut leavin)
    //     pthread_join(exited[i],NULL); 
    // }

    // pthread_join(counter_sec,NULL); //run infinitely

    printf("\n%d coffee wasted\n",wasted_cofee);
    printf("Average time a customer excluding coffee prep %f\n",waiting_time/n);// /n


    pthread_cond_destroy(&cond_swapn );pthread_cond_destroy(&cond_sec );pthread_cond_destroy(&cond_arrival );
    sem_destroy(&semaphore);sem_destroy(&binary_sem);
    pthread_mutex_destroy(&mutex);pthread_mutex_destroy(&mutex2);pthread_mutex_destroy(&mutex_s);pthread_mutex_destroy(&arrival_mutex);

}

 //  took data input   //
    // printf("hii\n");
    // printf("%d %d %d\n",b,k,n);
    // for(int i=0;i<k;i++){
    //     printf("%s %d\n",map.data[i].key,find(map.data[i].key));
    // }
    // for(int i=0;i<n;i++){
    //     printf("%d %s %d %d\n", arr[i].i, arr[i].cof, arr[i].t_arr_i, arr[i].tol_i);
    // }
     

/*
Report : expand further
we make 3 types of thread
1) seconds counter which broadcast all threads waiting by cond_s condition variable
2) it is array of threads ,ensure to print arrival time at correct instant
3) it is array of threads which does all logical waiting and printing
   operations for wasted cofee ,average time is implement in these threads
4)coloring is done


*/
