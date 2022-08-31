#define VIDEO_MEM 0xb8000

void kmain();

void
entry() // we use this function as a trampoline to jump into main 
{
    kmain();
}


void print(char* message)
{
    char* p_video_buffer = (char*) VIDEO_MEM;
    char* p_next_char = message;
    while(*p_next_char){
        *p_video_buffer = *p_next_char;        
        p_next_char++;
        p_video_buffer += 2;
    }

}


void
kmain()
{
    print("We are executing our C kernel !!!!");
    while(1){

    }

}