#include <stdio.h>
#include<string.h>
#include <dlfcn.h>

int main()
{
    char op[6];
    int num1, num2;

    void *handle = NULL;
    char loaded_op[6] = "";

    while(scanf("%5s %d %d", op,&num1,&num2)==3)
    {
        if(strcmp(op,loaded_op)!=0)
        {
            if(handle)
            {
                dlclose(handle);
                handle = NULL;
            }

            char libname[14];
            snprintf(libname, sizeof(libname), "./lib%s.so", op);
            // snprintf(libname, sizeof(libname), "lib%s.so", op);

            handle = dlopen(libname,RTLD_LAZY);

            if(!handle)
            {
                fprintf(stderr, "dlopen failed: %s\n", dlerror());
                return 1;
            }
            strncpy(loaded_op, op, 5);
            loaded_op[5] = '\0';
        }

        typedef int (*op_fn)(int ,int);
        op_fn fn = (op_fn) dlsym(handle, op);

        char *err = dlerror();

        if (err) 
        {
            fprintf(stderr, "dlsym failed: %s\n", err);
            return 1;
        }

        printf("%d\n", fn(num1, num2));
        
        dlerror();

    }

    if (handle) dlclose(handle);
    return 0;
}