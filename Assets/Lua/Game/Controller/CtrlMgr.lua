local M = {}

--登录模块
M.CtrlLogin =  import(".Login.CtrlLogin")

return M






typedef struct node {
    int data;
    struct node * next;
} NODE;


void resort (node* head)
{
    //快慢指针
    node* fast = head;
    node* slow = head;
    //快慢指针找到中间点
    while(fast&&fast->next)
    {
        slow = slow->next;
        fast = fast->next->next;
    }

}


1 2 3 4

1 2 3 4 5