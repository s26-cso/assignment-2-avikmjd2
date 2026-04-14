#include <stdio.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

struct Node* make_node(int val);
struct Node* insert(struct Node* root, int val);
struct Node* get(struct Node* root, int val);
int getAtMost(int val, struct Node* root);

int main() {
    struct Node* root = NULL;
    root = insert(root, 10);
    root = insert(root, 5);
    root = insert(root, 15);
    root = insert(root, 7);

    printf("%d\n", get(root, 7) ? 1 : 0);   // 1
    printf("%d\n", get(root, 9) ? 1 : 0);   // 0
    printf("%d\n", getAtMost(8, root));      // 7
    printf("%d\n", getAtMost(10, root));     // 10
    printf("%d\n", getAtMost(4, root));      // -1
    return 0;
}
