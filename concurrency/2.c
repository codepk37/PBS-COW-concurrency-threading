
#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<pthread.h>
#include <string.h>
#include <semaphore.h>
#define YELLOW "\x1b[33m"
#define RED  "\x1b[31;2m"
#define CYAN "\x1b[36m"
#define BLUE "\x1b[34m"
#define GREEN "\x1b[32m"
#define ORANGE  "\x1b[38;5;202m"  
#define RESET "\x1b[0m"
#include <stdbool.h>
#define MAX_SIZE 200
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
pthread_mutex_t mutex_map;
void insert(char key[100], int value) {
    pthread_mutex_lock(&mutex_map);
    for (int i = 0; i < map.size; i++) {
        if (strcmp(map.data[i].key, key) == 0) {
            // Key already exists, update the value
            map.data[i].value = value;
        }
    }
    // Key doesn't exist, check if there's space to insert
    if (map.size < MAX_SIZE) {
        strcpy(map.data[map.size].key, key);
        map.data[map.size].value = value;
        map.size++;
    }
    pthread_mutex_unlock(&mutex_map);
} //insert("coco", 4); insert("coco", 2); double insert works 
int find(const char key[100]) {
    for (int i = 0; i < map.size; i++) {
        if (strcmp(map.data[i].key, key) == 0) {
            return map.data[i].value;
        }
    }
    return -1;
}//find("coco");

typedef struct m{
    int tm_start;
    int tm_stop;
}machine;
machine* mac;

typedef struct fa{
    char f[100];
    int t_f;

}flavour;
flavour* fav;

typedef struct to{
    char t[100];
    int q_t;
}topping;
topping* top;


typedef struct ord{
    char flav[100];
    char **toppings;
    int tot_topping;
}order;

        
typedef struct c{
    int c;              //index of customer
    int t_arr;          //arrival 
    int num_icecream;     //number of ice_cream
    order* orders;
}customer;
//--
int n,k,f,t;
customer *arr;
int tot_customer=0;
//-- 



int maxtime=-1;
int *done; //cust all made
int *ingredients;//cust ingred allocated
pthread_mutex_t mutex_s;pthread_cond_t cond_sec;
//all mutex delacre
pthread_mutex_t mutex;
int sec=-1;
int *marr;
void *counter(){
    while(1){
    sleep(1);
    sec++;
    // printf("time: %d \n",sec);

    // printf("machine: ");
    // for(int i=0;i<n;i++){
    //     printf("%d ",marr[i]);
    // }printf("\n ");    
    pthread_cond_broadcast(&cond_sec);
    
    }
}

void* machine_handler(void* arg){
    int ind=*(int *)arg;
    free(arg);
    int start=mac[ind].tm_start;
    int stop=mac[ind].tm_stop;

    pthread_mutex_lock(&mutex_s);
    while( start>sec ){  //check index
        pthread_cond_wait(&cond_sec, &mutex_s);
    }
    pthread_mutex_unlock(&mutex_s);
    // printf("Machine %d has started working at %d second(s)\n",ind+1,sec);
    printf(ORANGE "Machine %d has started working at %d second(s)\n" RESET, ind + 1, sec);



    pthread_mutex_lock(&mutex_s);
    while( stop>sec ){  //check index
        pthread_cond_wait(&cond_sec, &mutex_s);
    }
    pthread_mutex_unlock(&mutex_s);
    // printf("Machine %d has stopped working at %d second(s)\n",ind+1,sec);
    printf(ORANGE "Machine %d has stopped working at %d second(s)\n" RESET, ind + 1, sec);

}

// for toppings of i'th customer
typedef struct {
    char key[100];
    int value;
} KeyValue;

typedef struct {
    KeyValue data[MAX_SIZE];
    int size;
} MapT;

void initializeTOPM(MapT *map) {
    map->size = 0;
}

bool insertOrUpdateTopping(MapT *map, const char *key) {
    for (int i = 0; i < map->size; i++) {
        if (strcmp(map->data[i].key, key) == 0) {
            // Topping already exists, update the count
            map->data[i].value++;
            return true;
        }
    }

    // Topping doesn't exist, insert it
    if (map->size < MAX_SIZE) {
        strcpy(map->data[map->size].key, key);
        map->data[map->size].value = 1;
        map->size++;
        return true;
    }

    return false;
}


int cind =0;
int spawned;


pthread_cond_t cond_swapn;pthread_mutex_t mutex_swapn;

pthread_cond_t verfastswap;int scheduler=0;
void* arrival_handler(void* arg){
    int ind=*(int *)arg;
    free(arg);
    // tot_customer

    ///   //fastswaps customer order to index wise
    while(ind >scheduler){
        pthread_mutex_lock(&mutex);
        pthread_cond_wait(&verfastswap,&mutex);   //indexwise  
        pthread_mutex_unlock(&mutex);
    } 
    pthread_mutex_lock(&mutex);
    scheduler++;
    pthread_mutex_unlock(&mutex);
    pthread_cond_broadcast(&verfastswap);//send up sifnal lowest ind has entered
    /////    


    pthread_mutex_lock(&mutex);
    while( arr[ind].t_arr>sec ){  //check arrival time_wise
        pthread_cond_wait(&cond_sec, &mutex);
    }
    pthread_mutex_unlock(&mutex);
    //arrived  check for place

    if(cind<spawned){
        //order icecream
        pthread_mutex_lock(&mutex); //single line printing
        printf("Customer %d enters at %d second(s)\n",arr[ind].c,arr[ind].t_arr);
           
        /*printf("Customer %d orders %d ice creams\n",arr[ind].c,arr[ind].num_icecream);
        for(int i=0;i<arr[ind].num_icecream;i++){
            printf("Ice cream %d: %s ",i+1,arr[ind].orders[i].flav);
            for(int t=0;t<arr[ind].orders[i].tot_topping;t++){
                printf("%s ",arr[ind].orders[i].toppings[t]);
            }
            printf("\n");
        }
        */
        printf(YELLOW "Customer %d orders %d ice creams\n" RESET, arr[ind].c, arr[ind].num_icecream);
        for (int i = 0; i < arr[ind].num_icecream; i++) {
            printf(YELLOW "Ice cream %d: %s " RESET, i + 1, arr[ind].orders[i].flav);
            for (int t = 0; t < arr[ind].orders[i].tot_topping; t++) {
                printf(YELLOW "%s " RESET, arr[ind].orders[i].toppings[t]);
            }
            printf(YELLOW "\n" RESET);
        }
        pthread_mutex_unlock(&mutex);
        //given order

        //check ingredients 
        MapT toppingsMap;
        initializeTOPM(&toppingsMap);
        for (int i = 0; i < arr[ind].num_icecream; i++) {
            for (int t = 0; t < arr[ind].orders[i].tot_topping; t++) {
                pthread_mutex_lock(&mutex);
                insertOrUpdateTopping(&toppingsMap, arr[ind].orders[i].toppings[t]); // Update topping count
                pthread_mutex_unlock(&mutex);
            }
        }
        
        // Print the total count of each topping
        pthread_mutex_lock(&mutex);
        bool flag=1; //check sufficient ingredient?
        for (int i = 0; i < toppingsMap.size; i++) {
            // printf("before %s: %d\n", toppingsMap.data[i].key, find(toppingsMap.data[i].key));
            if(toppingsMap.data[i].value<=find(toppingsMap.data[i].key) ||find(toppingsMap.data[i].key)==-1){/*ok*/ }
            else{
                flag=0; break;
            }
        }
        if(flag==1){//will take ingredients
            
            for (int i = 0; i < toppingsMap.size; i++) {
                // printf("%s: %d\n", toppingsMap.data[i].key, toppingsMap.data[i].value);
                if(find(toppingsMap.data[i].key)==-1){//infinite
                    continue;
                }
                insert(toppingsMap.data[i].key,find(toppingsMap.data[i].key)-toppingsMap.data[i].value);
                // printf("after %s: %d\n", toppingsMap.data[i].key, find(toppingsMap.data[i].key));
            }
            //updated reduced ingedients
            ingredients[ind]=1; //make icecream  //****************given to ind
            //given ingredients to ind customer
        }
        else{//no ingredients
            // printf("Customer %d left at %d second(s) with an unfulfilled order\n",ind+1,sec);
            printf(RED "Customer %d left at %d second(s) with an unfulfilled order\n" RESET, ind + 1, sec);
            ///------
            done[ind]=arr[ind].num_icecream ;//show to exit_handler ,order has taken care before all machine stops 
                        
            //just not to make this machine instantly avaiabe at leaving second 
            // delay is automatically taken care

            // int cur=sec;  // I have Q.30 ,
            // while(cur+1>sec){  //~sleep(1) only
            //     pthread_cond_wait(&cond_sec,&mutex); //exactly 1 sec sleep ,before giving resources  MACHINE
            // }
                            //as 

            spawned++; //cust left
            cind++;
            ingredients[ind]=0;//exit icecream
            pthread_mutex_unlock(&mutex);
            return NULL;
        }
        pthread_mutex_unlock(&mutex);
        pthread_cond_broadcast(&cond_swapn);

        //till here cust arrive with allocated ingredient 
        //  //there are no unnecssary wait ,everything is acc to calcuation// //
        // so here wont be any delay 

        //wait till all custoem's order are completed
        
        pthread_mutex_lock(&mutex_swapn);
        cind++;  //one cust got all his icecream
        while(done[ind]< arr[ind].num_icecream){ //wait till all icecream are made
            pthread_cond_wait(&cond_swapn, &mutex_swapn);
        }
        spawned++;
        // printf("\n");
        pthread_mutex_unlock(&mutex_swapn);
        
        //spawn customer all icecream

    }
    else{
        //cust go away
        pthread_mutex_lock(&mutex);
        printf("Customer %d sees that the parlour is full, and goes away\n",arr[ind].c);
                   
        //  //
        cind++;
        spawned++;
        ingredients[ind]=0;//exit icecream
        pthread_mutex_unlock(&mutex);
    }

    

}
int total_icecream=0;
typedef struct p{int a;int b;int time;}pair;
pair *queu; //of  cust,icecream
//
pthread_mutex_t mutex_q;
pthread_cond_t cond_q;
pthread_cond_t fastswap;



int scheduleind=0;
void * queue_hand(void * arg){ //tot_icecream
    int cur_ind= *(int*)arg;
    free(arg);

    //k customer thing in- func arrival 
    //ingredients thing in- func arrival 

    while(ingredients[queu[cur_ind].a-1]==-1){//waiting ==-1 ingredients not allocated
        pthread_mutex_lock(&mutex);
        pthread_cond_wait(&cond_sec, &mutex);
        pthread_mutex_unlock(&mutex);
    }
    // printf("icecream number : %d\n",cur_ind);
    
    ///   //fastswaps icream order to index wise
    while(cur_ind >scheduleind){
        pthread_mutex_lock(&mutex);
        pthread_cond_wait(&fastswap,&mutex);   //indexwise  
        pthread_mutex_unlock(&mutex);
    } 
    pthread_mutex_lock(&mutex);
    scheduleind++;
    pthread_mutex_unlock(&mutex);
    pthread_cond_broadcast(&fastswap);//send up sifnal lowest ind has entered
    /////


    if(ingredients[queu[cur_ind].a-1]==0){ // k custfilled or no ingredients of cust order =0
        return NULL;  //exit thread
    }

    //ingedients[]=1 here
    //all icecream valid reach here ,just give it to machine now
    //acc to time ,ingredients ,and cust_number
    //else wait  

    // queu[cur_ind].a;queu[cur_ind].b;queu[cur_ind].time
    int got=-1;int came;
    

    while(got==-1){ //to take mac
        for(int i=0;i<n;i++){
            pthread_mutex_lock(&mutex);
            bool canaccept= sec + queu[cur_ind].time < mac[i].tm_stop;//comletion check ,strict before end
            
            if(sec>=mac[i].tm_start && sec<=mac[i].tm_stop && marr[i]==0 && 
                 canaccept    ){
                marr[i]=1; //took mac
                got=i;
                came=sec;
                pthread_mutex_unlock(&mutex);
                break;
            }
            pthread_mutex_unlock(&mutex);
        }
        if(got==-1){
            // pthread_cond_wait(&cond_q,&mutex_q);
            pthread_mutex_lock(&mutex);
            pthread_cond_wait(&cond_sec,&mutex);
            pthread_mutex_unlock(&mutex);
        }

    }
    //it took mac[got]
    // printf("ICECREAM %d GOT MACHINE AT %d\n",cur_ind,sec);
    int curr;
    while(arr[queu[cur_ind].a-1].t_arr +1 >sec){  //sleep 1 -~only if spawned last second
        pthread_mutex_lock(&mutex);
        pthread_cond_wait(&cond_sec, &mutex);  //if it was spawned before,long time,so wont wait
        pthread_mutex_unlock(&mutex);        
    }
    curr=sec;//from now curr ,wait its making time

    // printf("Machine %d starts preparing ice cream %d of customer %d at %d second(s)\n",got+1,queu[cur_ind].b,queu[cur_ind].a,sec);
     printf(CYAN "Machine %d starts preparing ice cream %d of customer %d at %d second(s)\n" RESET, got + 1, queu[cur_ind].b, queu[cur_ind].a, sec);


    //wait queu[cur_ind].time secs
    while((curr)+queu[cur_ind].time>sec){  
        pthread_mutex_lock(&mutex);
        pthread_cond_wait(&cond_sec, &mutex);
        pthread_mutex_unlock(&mutex);
    }

    // printf("GOING TO RELEASE MAC %d\n",got+1);
    pthread_mutex_lock(&mutex);
    marr[got]=0;  //released machine
    done[queu[cur_ind].a-1]++;  //to arrival ~ if (check cust all order done) 
    // pthread_cond_broadcast(&cond_q); //to machine

    // printf("Machine %d completes preparing ice cream %d of customer %d at %d seconds(s)\n",got+1,queu[cur_ind].b,queu[cur_ind].a,sec);
    printf(BLUE "Machine %d completes preparing ice cream %d of customer %d at %d seconds(s)\n" RESET, got + 1, queu[cur_ind].b, queu[cur_ind].a, sec);


    if(done[queu[cur_ind].a-1]==arr[queu[cur_ind].a-1].num_icecream){ //end order of cust
        // printf("Customer %d has collected their order(s) and left at %d second(s)\n",queu[cur_ind].a,sec);
        printf(GREEN "Customer %d has collected their order(s) and left at %d second(s)\n" RESET, queu[cur_ind].a, sec);

    }

    pthread_mutex_unlock(&mutex);
    
    pthread_cond_broadcast(&cond_swapn); //to arrival ~ if (check cust all order done)
    

    
    // printf("----\n");

}

void* exit_handler(void* arg){
    pthread_mutex_lock(&mutex);
    while(maxtime+1>sec){
        pthread_cond_wait(&cond_sec,&mutex);
    }
    pthread_mutex_unlock(&mutex);
    
    //now time to exit
    //check which cust remained unserved
    for(int i=0;i<tot_customer;i++){
        // printf("%d %d \n",arr[i].num_icecream ,done[i] );
        if(arr[i].num_icecream >done[i] ){
            // printf("Customer %d was not serviced due to unavailability of machines\n",i+1);
            
            printf(RED "Customer %d was not serviced due to unavailability of machines\n" RESET, i + 1);
            

        }
    }
    printf("Parlour Closed\n");
    exit(0);
}



// code

//make inpput 
//understand problem
//take codevault program website help

int main(){
    // int n,k,f,t;
    // int maxtime=-1;
    scanf("%d %d %d %d",&n,&k,&f,&t);//machine ,customer_capacity ,flavours ,toppings
    initializeMap();
    spawned=k;
    mac=(machine*)malloc(n*sizeof(machine));
    for(int i=0;i<n;i++){
        scanf("%d %d",&mac[i].tm_start,&mac[i].tm_stop);
        if(maxtime<mac[i].tm_stop){maxtime=mac[i].tm_stop;}
    }
    // printf("MAXTIME : %d\n",maxtime);
    
    
    marr=(int*)malloc(n*sizeof(int));
    for(int i=0;i<n;i++){
        marr[i]=0;
    }
    
    fav=(flavour*)malloc(f*sizeof(flavour));
    for(int i=0;i<f;i++){
        scanf("%s %d",fav[i].f, &fav[i].t_f);//t_f time to prepare
        insert(fav[i].f, fav[i].t_f);
    }

    top=(topping*) malloc(t* sizeof(topping));
    for(int i=0;i<t;i++){
        scanf("%s %d",top[i].t, &top[i].q_t);//q_t =-1 for infinite topping
        insert(top[i].t, top[i].q_t);
    }
    getchar(); // // Clear newline character
    
    while (1)
    {   
        // printf("hi1\n");
        char *input = NULL;
        size_t z = 50;
        ssize_t sze =getline(&input, &z, stdin);
        if(sze==1){break;}

        arr=(customer*)realloc(arr,(tot_customer+1)*sizeof(customer));
      
        sscanf(input, "%d %d %d", &arr[tot_customer].c, &arr[tot_customer].t_arr, &arr[tot_customer].num_icecream);
        
        total_icecream+=arr[tot_customer].num_icecream;//count +=tot_cream


        arr[tot_customer].orders=(order*)malloc(arr[tot_customer].num_icecream* sizeof(order));
        
        for(int i=0;i<arr[tot_customer].num_icecream;i++){
            
            getline(&input, &z, stdin);
            int numTokens = 0;
           
            arr[tot_customer].orders[i].toppings = NULL; // int **arr
        
            char *token = strtok(input, " \t\n");  // Split on space, tab, and newline

            strcpy(arr[tot_customer].orders[i].flav,token); 

            token = strtok(NULL, " \t\n");
            while (token != NULL) {
                // printf("hi4\n");
                // Allocate memory for each token
                arr[tot_customer].orders[i].toppings = (char **)realloc(arr[tot_customer].orders[i].toppings, (numTokens + 1) * sizeof(char *));
                arr[tot_customer].orders[i].toppings[numTokens] = strdup(token);
                numTokens++;
                token = strtok(NULL, " \t\n");
            }
           
            arr[tot_customer].orders[i].tot_topping=numTokens;                
        }
        tot_customer++;   


    }
    printf("hi5\n");
    int z=0;
    queu=(pair*) malloc(total_icecream* sizeof(pair));
    for(int i=0;i<tot_customer;i++){
        for(int j=0;j<arr[i].num_icecream;j++){
            queu[z].a=i+1;queu[z].b=j+1;
            //find time to make

            queu[z].time= find(arr[i].orders[j].flav);
            
            z++;

        }
    }

    done=(int*)malloc(tot_customer*sizeof(int));
    ingredients=(int*)malloc(tot_customer*sizeof(int));
    for(int i=0;i<tot_customer;i++){
        done[i]=0;
        ingredients[i]=-1;//wait icecream
    }
    pthread_mutex_init(&mutex_s, NULL);pthread_mutex_init(&mutex, NULL);pthread_mutex_init(&mutex_q, NULL);pthread_mutex_init(&mutex_map, NULL);pthread_mutex_init(&mutex_swapn, NULL);
    pthread_cond_init(&cond_sec , NULL);pthread_cond_init(&cond_q , NULL);pthread_cond_init(&fastswap , NULL);pthread_cond_init(&verfastswap , NULL);


    
    pthread_t counter_sec;
    pthread_create(&counter_sec,NULL,&counter,NULL);


    pthread_t qu[total_icecream]; //(1 1),(1 2),(2 1)
    for(int i=0;i<total_icecream;i++){
        int *a=(int*)malloc(sizeof(int)); 
        *a=i;
        pthread_create(&qu[i],NULL,&queue_hand,a);
    }

    
    
    //WORKS GOOD:print machine start ,stop 
    pthread_t ma[n];
    for(int i=0;i<n;i++){
        int *a=(int*)malloc(sizeof(int)); 
        *a=i;
        pthread_create(&ma[i],NULL,&machine_handler,a);
    } 



    //  WORKS GOOD: for arrival pring order's
    pthread_t arrival[tot_customer];
    for(int i=0;i<tot_customer;i++){
        int *a=(int*)malloc(sizeof(int)); 
        *a=i;
        pthread_create(&arrival[i],NULL,&arrival_handler,a);
    }

    pthread_t ex;
    pthread_create(&ex,NULL,&exit_handler,NULL);

     for(int i=0;i<tot_customer;i++){
        pthread_join(arrival[i],NULL); //customer
    }

    pthread_join(ex,NULL); //is till EXIT,
    
     //done:mac run stop
    // for(int i=0;i<total_icecream;i++){
    //     printf("queue: %d %d \n",queu[i].a,queu[i].b);
    // }
    

    /*for(int i=0;i<n;i++){  //WORKS GOOD
        pthread_join(ma[i],NULL); //just mac prinitng
    }*/
    
    // for(int i=0;i<total_icecream;i++){
    //     pthread_join(qu[i],NULL); //customer
    // }
    
     ///////    Works: for arrival pring order's
   
    
   
    // pthread_join(counter_sec,NULL);
    
    pthread_cond_destroy(&cond_sec );pthread_cond_destroy(&cond_q );
    pthread_mutex_destroy(&mutex_s);pthread_mutex_destroy(&mutex);pthread_mutex_destroy(&mutex_q);
}

 // printf("%d %d %d %d\n",n,k,f,t);
    // for(int i=0;i<n;i++){
    //     printf("%d %d\n",mac[i].tm_start,mac[i].tm_stop);
    // }
    // for(int i=0;i<f;i++){
    //     printf("%s %d\n",fav[i].f, find(fav[i].f));//t_f time to prepare key:value
    // }
    // for(int i=0;i<t;i++){
    //     printf("%s %d\n",top[i].t, find(top[i].t));//q_t =-1 for infinite topping
    // }

    
    // for (int i = 0; i < tot_customer; i++) {
    //     // printf("Customer %d, Arrival Time: %d, Number of Ice Creams: %d\n", arr[i].c, arr[i].t_arr, arr[i].num_icecream);
    //     printf("%d %d %d\n", arr[i].c, arr[i].t_arr, arr[i].num_icecream);
    //     for (int j = 0; j < arr[i].num_icecream; j++) {
    //         // printf("Ice Cream %d, Flavor: %s, Toppings:\n", j, arr[i].orders[j].flav);
    //         printf("Flavor: %s\ntoppings :\n",arr[i].orders[j].flav);
    //         for (int k = 0; k < arr[i].orders[j].tot_topping; k++) {
    //             printf("%s\n", arr[i].orders[j].toppings[k]);
    //         }
    //     }
    // }


    /*
    REAdme: REPORT
    if customer come same time ,index wise spawning is done
    (to all possible machines)

    if icecream/customer's are already spawned -> can execute any order
    */
    

