#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct point Point;
typedef struct node Node;
typedef struct queue Queue;

const int dirs[4][2] = { {1, 0}, {0, 1}, {-1, 0}, {0, -1} };
const char dir_chars[4] = { 'D', 'R', 'U', 'L' };

struct point {
    int x, y;
};

void print_point(const Point* p) {
    printf("Point(%d, %d)\n", p->x, p->y);
}

struct node {
    int value, dist;
    bool visited;
    Point pos;
    Point pred;
};

struct queue {
    int front, rear, size, cap;
    Node** array;
};

Queue* make_queue(int cap) {
    Queue* q = (Queue*) malloc(sizeof(Queue));
    *q = (Queue) { .front = 0, .rear = cap - 1, .size = 0, .cap = cap };
    q->array = (Node**) malloc(cap * sizeof(Node*));
    return q;
}

void destruct_queue(Queue* q) {
    free(q->array);
    free(q);
}

bool is_empty(Queue* q) {
    return q->size == 0;
}

bool is_full(Queue* q) {
    return q->size == q->cap;
}

void enqueue(Queue* q, Node* n) {
    if (is_full(q))
        abort();
    q->rear = (q->rear + 1) % q->cap;
    q->array[q->rear] = n;
    q->size += 1;
}

Node* dequeue(Queue* q) {
    if (is_empty(q))
        abort();
    Node* res = q->array[q->front];
    q->front = (q->front + 1) % q->cap;
    q->size -= 1;
    return res;
}


void print_node(const Node* node) {
    printf("Node(");
    printf("%d, ", node->value);
    printf("%s, ", node->visited ? "true": "false");
    printf("pos: {%d, %d}, ", node->pos.x, node->pos.y);
    printf("pred: {%d, %d}", node->pred.x, node->pred.y);
    printf(")\n");
}

void read_matrix(Node m[][100], int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            m[i][j] = (Node) { .visited = false, .dist = -1, .pred = (Point) {0, 0} };
            m[i][j].pos = (Point) { .x = i, .y = j };
            int temp;
            scanf("%d", &temp);
            m[i][j].value = temp;
        }
    }
}

void print_matrix(Node m[][100], int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            print_node(&m[i][j]);
        }
        printf("\n");
    }
}

bool is_prime(int n) {
    if (n <= 1)
        return false;
    if (n <= 3)
        return true;

    if (n % 2 == 0 || n % 3 == 0)
        return false;

    for (int i = 5; i * i <= n; i += 6) {
        if ((n % i == 0) || (n % (i + 2) == 0)) {
            return false;
        }
    }
    return true;
}

void make_obstacles(Node m[][100], int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (!is_prime(m[i][j].value)) {
                m[i][j].visited = true;
            }
        }
    }
}

void read_points(Point* src, Point* dest) {
    scanf("%d %d", &src->x, &src->y);
    scanf("%d %d", &dest->x, &dest->y);
}

bool is_in_grid(Point* p, int n) {
    if (p->x < 0 || p->x >= n) {
        return false;
    } else if (p->y < 0 || p->y >= n) {
        return false;
    } else {
        return true;
    }
}

void modified_bfs(Node* v, Node m[][100], int n, Queue* q) {
    // printf("current node: ");
    // print_node(v);
    v->visited = true;
    
    for (int i = 0; i < 4; i++) {
        Point p = { .x = v->pos.x + dirs[i][0], .y = v->pos.y + dirs[i][1] };
        if (is_in_grid(&p, n)) {
            if (!m[p.x][p.y].visited) {
                m[p.x][p.y].dist = v->dist + 1;
                m[p.x][p.y].pred = (Point) { .x = -dirs[i][0], .y = -dirs[i][1] };
                enqueue(q, &m[p.x][p.y]);
            }
        }
    }
}

void print_path_not_found() {
    printf("No Monaseb Masir!\n");
}

void print_path(Node m[][100], const Point* dest) {
    int size = m[dest->x][dest->y].dist;
    Point cur = { .x = dest->x, .y = dest->y };
    char* res = (char*) malloc(size * sizeof(char));

    for (int i = 0; i < size; i++) {
        Node* cur_node = &m[cur.x][cur.y];
        for (int j = 0; j < 4; j++) {
            if (-cur_node->pred.x == dirs[j][0] && -cur_node->pred.y == dirs[j][1]) {
                res[size - i - 1] = dir_chars[j];
            }
        }
        cur.x += cur_node->pred.x;
        cur.y += cur_node->pred.y;
    }

    for (int i = 0; i < size; i++) {
        printf("%c", res[i]);
    }
    printf("\n");
    free(res);
}

void find_path(Node m[][100], int n, const Point* src, const Point* dest) {
    Queue* q = make_queue(n * n);
    Node* src_node = &m[src->x][src->y];
    
    src_node->dist = 0;
    enqueue(q, src_node);
    
    while(!is_empty(q)) {
        Node* v = dequeue(q); 
        modified_bfs(v, m, n, q);
    }
    
    destruct_queue(q);

    if (m[dest->x][dest->y].dist == -1) {
        print_path_not_found();
    }
    else {
        print_path(m, dest);
    }
}

void process_query() {
    Node mtx[100][100];
    Point src, dest;
    int n;
    
    scanf("%d", &n);
    
    read_matrix(mtx, n);
    make_obstacles(mtx, n);
    read_points(&src, &dest);
    find_path(mtx, n, &src, &dest);
}

void process_tests(int t) {
    for (int i = 0; i < t; i++) {
        process_query();
    }
}

int main() {
    int t;
    scanf("%d", &t);
    process_tests(t);
}