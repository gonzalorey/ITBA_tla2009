/* LinkedList.c  */


#include <stdlib.h>

#include "LinkedList.h"


struct LinkedListCDT {
	struct node_t *head;
	struct node_t *last;
	struct node_t *current;
	int size;
};

struct node_t {
	void *element;
	struct node_t *next;
};



LinkedList_t newLinkedList(){

	LinkedList_t list;

	if((list = malloc(sizeof(struct LinkedListCDT))) == NULL){
		return NULL;
	}

	list->current = NULL;
	list->head = NULL;
	list->last = NULL;
	list->size = 0;

	return list;
}


int LinkedListInsert(LinkedList_t list, void *element){

	struct node_t *node;

	if((node = malloc(sizeof(struct node_t))) == NULL)
		return 0;


	node->element = element;
	node->next = NULL;

	if(LinkedListIsEmpty(list)){
		list->head = node;
	} else {
		list->last->next = node;
	}

	list->last = node;
	list->size++;

	return 1;

}

int LinkedListSize(LinkedList_t list){
	return list->size;
}


int LinkedListIsEmpty(LinkedList_t list) {
	return LinkedListSize(list) == 0;
}

void LinkedListBeginIterator(LinkedList_t list){
	list->current = list->head;
}

int LinkedListHasNext(LinkedList_t list){
	return list->current != NULL;
}

void *LinkedListGetNext(LinkedList_t list){
	void *element;


	element = list->current->element;
	list->current = list->current->next;

	return element;
}

void FreeLinkedList(LinkedList_t list){

	struct node_t *cur;
	struct node_t *next;

	cur = list->head;

	while(cur != NULL){
		next = cur->next;
		free(cur);
		cur = next;
	}

	free(list);
}
