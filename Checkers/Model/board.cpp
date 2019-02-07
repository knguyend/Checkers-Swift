//
//  board.cpp
//  Checkers
//
//  Created by Khang Nguyen on 1/9/19.
//  Copyright © 2019 Khang Nguyen. All rights reserved.
//

#include <stdio.h>
#include "log.h"
class board {
    // check if mallocs were done correctly
    void check_null(void *ptr, char const *msg) {
        if (ptr == NULL) {
            c << "%s\n" << msg;
            exit(EXIT_FAILURE);
        }
    }

    // construct new board, computer starts first
    Board *init_board(int COMPUTER, int USER) {
        // store values of pieces for each player
        // normal pieces worth 3 units, kings worth 5
        Board *board = (Board *) malloc(sizeof(Board));
        check_null(board, "Unable to allocate board\n");
        
        board->COMPUTER = COMPUTER;
        board->USER = USER;
        
        // initialize all as '-'
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++)
                board->board[i][j] = '-';
        }
        
        // initialize computer pieces
        bool skip = true;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 8; j++) {
                if (!skip)
                    board->board[i][j] = 'c';
                skip = !skip;
            }
            skip = !skip;
        }
        
        // initialize user pieces
        skip = false;
        for (int i = 5; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                if (!skip)
                    board->board[i][j] = 'u';
                skip = !skip;
            }
            skip = !skip;
        }
        return board;
    }


    // duplicate board, for children
    Board *copyBoard(Board *board) {
        Board *newBoard = init_board(board->COMPUTER, board->USER);
        
        // copy board array
        for (int i = 0; i < 8; i++) {
            for(int j = 0; j < 8; j++)
                newBoard->board[i][j] = board->board[i][j];
        }
        return newBoard;
    }

    // make a legit move
    void updateBoard(Board *board, coordinate curr, coordinate next, char player) {
        bool jump = 0;
        if (curr.row - next.row == 2 || curr.row - next.row == -2)
            jump = 1;
        
        if (jump) {
            int enemyR = (curr.row + next.row)/2;
            int enemyC = (curr.col + next.col)/2;
            
            // cout << "Piece at (" << enemyR << ", " << enemyC << ") destroyed!" <<endl;
            
            int enemyPieceValue = 3; // assume normal piece was destroyed
            if (isupper(board->board[enemyR][enemyC]))
                enemyPieceValue = 5; // king was destroyed
            
            board->board[enemyR][enemyC] = '-'; // die
            if (player == 'u') // enemy loses one piece
                board->COMPUTER -= enemyPieceValue;
            else
                board->USER -= enemyPieceValue;
        }
        
        // make king if they reached the end
        if (next.row == 0 || next.row == 7) {
            board->board[curr.row][curr.col] = toupper(board->board[curr.row][curr.col]);
            if (islower(board->board[curr.row][curr.col])) {
                if (player == 'u')
                    board->USER +=2;
                else
                    board->COMPUTER +=2;
            }
        }
        
        // shift position of piece
        board->board[next.row][next.col] = board->board[curr.row][curr.col];
        board->board[curr.row][curr.col] = '-';
        
    }


    // print to stdout
    void toString(Board *board, int tab) {
        for (int i = 0; i < 8; i++) {
            for (int k = 0; k < tab; k++)
                cout << " ";
            for (int j = 0; j < 8; j++)
                cout << board->board[i][j];
            cout << endl;
        }
    }
}
