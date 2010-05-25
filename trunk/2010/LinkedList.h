/* LinkedList.h */

#ifndef LINKEDLIST_H_
#define LINKEDLIST_H_


typedef struct LinkedListCDT *LinkedList_t;


LinkedList_t newLinkedList();

int LinkedListInsert(LinkedList_t list, void *element);

int LinkedListSize(LinkedList_t list);

int LinkedListIsEmpty(LinkedList_t list);

void LinkedListBeginIterator(LinkedList_t list);

int LinkedListHasNext(LinkedList_t list);

void *LinkedListGetNext(LinkedList_t list);

void FreeLinkedList(LinkedList_t list);


#endif /* LINKEDLIST_H_ */
