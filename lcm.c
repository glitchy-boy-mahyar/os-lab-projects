#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

// our program will accept at most 8 inputs
const int LCM_ARR_SZ = 8;

// a 32-bit integer will not have more than 16 digits
const int MAX_RES_WIDTH = 16;

const char NEWLINE[1] = {'\n'};

int gcd(int a, int b) {
    if (b == 0)
        return a;
    return gcd(b, a % b);
}

int lcm(int a, int b) { return a * b / gcd(a, b); }

void fill_nums(int nums[], int n, char* argv[]) {
    for (int i = 0; i < n; ++i) {
        nums[i] = atoi(argv[i + 1]);
    }
}


// finds lcm of all input numbers
// using the semi-recursive approach below:
// lcm(a, b, c) = lcm(a, lvm(b, c))

int find_lcm(int nums[], int n) {
    int l = lcm(nums[0], nums[1]);
    for (int i = 2; i < n; ++i) {
        l = lcm(l, nums[i]);
    }

    return l;
}

int digit_count(int l) {
    if (l == 0)
        return 1;
    
    int res = 0;
    for (int i = 0; i < MAX_RES_WIDTH; i++) {
        if (l == 0)
            break;
        
        l /= 10;
        res++;
    }

    return res;
}

char* str(int l, int dc) {    
    char* l_str = (char*) malloc((dc + 1) * sizeof(char));
    
    for (int i = 0; i < dc; i++) {
        int digit = l % 10;
        l /= 10;
        l_str[dc - i - 1] = '0' + digit;
    }

    return l_str;
}

int file_exists(char* file_name) {
    struct stat buf;
    return (stat(file_name, &buf) == 0);
}

void remove_file(char* file_name) {
    char* argv[3];
    argv[0] = "rm";
    argv[1] = file_name;
    argv[2] = 0;
    int pid = fork();
    if (pid > 0) {
        pid = wait();
    } else if (pid == 0) {
        exec("rm", argv);
    }
}

void write_to_file(char* file_name, int l) {
    int dc = digit_count(l);
    char* l_str = str(l, dc);
    int fd = open(file_name, O_CREATE | O_RDWR);
    write(fd, l_str, dc);
    write(fd, NEWLINE, 1);
    close(fd);
    free(l_str);
}

void write_result(int l) {
    char* file_name = "lcm_result.txt";
    if (file_exists(file_name))
        remove_file(file_name);
    write_to_file(file_name, l);
}

void process_lcm(int argc, char* argv[]) {
    int nums[LCM_ARR_SZ];
    int n = (LCM_ARR_SZ < argc - 1) ? LCM_ARR_SZ : argc - 1;
    fill_nums(nums, n, argv);
    
    int l = find_lcm(nums, n);
    write_result(l);
}

int main(int argc, char* argv[]) {    
    if (argc < 3) {
        printf(1, "lcm: too few arguments\n");
    } else {
        process_lcm(argc, argv);
    }
    exit();
}