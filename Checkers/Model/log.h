//
//  log.h
//  Checkers
//
//  Created by Khang Nguyen on 12/31/18.
//  Copyright © 2018 Khang Nguyen. All rights reserved.
//

#ifndef log_h
#define log_h
typedef struct coordinate {
    int row;
    int col;
} coordinate;

// Board array and total player values
typedef struct Board {
    int COMPUTER, USER; // value of pieces at start of a game
    char board[8][8];
} Board;

// node structure for minimax tree
typedef struct Node {
    Board *board;
    struct Node **children; // array of either pieces that can jump (preferred), or just move
    coordinate **list;
    coordinate *bestMove;
    int numChildren;
    int alpha;
    int beta;
    int value; // diff in # pieces: COMPUTER - USER;
} Node;

/* ------------------------------------------ */
/* ----------------FUNCTIONS----------------- */
/* ------------------------------------------ */

// board.cpp functions
void check_null(void *ptr, char const *msg);
Board *init_board(int COMPUTER = 12*3, int USER = 12*3); // construct new board, default parameters
Board *copyBoard(Board *board); // duplicate
void updateBoard(Board *board, coordinate curr, coordinate next, char player);
void toString(Board *board, int tab); // print to stdout
/* void flip(Board *board); // reverse direction (change turn) */

// checkmove.cpp move functions
coordinate init(int a, int b);
coordinate *buildMove(int r1, int c1, int r2, int c2);
bool canMove(Board *board, char player, int r1, int c1, int r2, int c2);
bool canJump(Board *board, char player, int r1, int c1, int r2, int c2);
coordinate **getMoves(Board *board, char player);
coordinate **getJumps(Board *board, char player);
void print_move(coordinate* move);

// node.cpp functions
Node *init_node(Board *board); // initialize tree node
void free_tree(Node *t); // free mallocs
void print_tree(Node *t, int tab, int depth); // prints tree using preorder traversal (for checking)

// ai.cpp intelligence functions
int size(coordinate **list);
bool isEmpty(coordinate **list);
coordinate *makeRandomMove(Board *board, char player);
Node *buildTree(Board *board, int depth, char player);
int minimax(Node *t, int depth, bool isMaximizingPlayer, int alpha, int beta);

#endif /* log_h */
