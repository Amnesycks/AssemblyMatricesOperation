#include <stdio.h>
#include <stdlib.h>

extern int** create_matrix(unsigned int nb_col, unsigned int nb_line);
extern int** add_matrix(int **matrix_a, int **matrix_b,
                        unsigned int nb_col, unsigned int nb_line);
extern int** sub_matrix(int **matrix_a, int **matrix_b,
                        unsigned int nb_col, unsigned int nb_line);
extern int** multiply_matrix(int **tab, int **tab2,
                           unsigned int nb_col_a, unsigned int nb_line_a,
                           unsigned int nb_col_b, unsigned int nb_line_b);

void print_matrix(int **matrix, int nb_col, int nb_line)
{
  if (matrix == NULL) {
    printf("NULL\n");
    return;
  }

  for ( int i = 0; i < nb_line; i++ ) {
      for ( int j = 0; j < nb_col; j++ ) {
         printf("%d ", matrix[i][j] );
      }
      printf("\n");
   }
   printf("\n");
}

void free_matrix(int **matrix, int nb_line)
{
  if (matrix) {
    for (int i = 0; i != nb_line; i++) {
      if (matrix[i])
        free(matrix[i]);
    }
    free(matrix);
  }
}

int main() {
  unsigned int nb_col_tab1 = 10;
  unsigned int nb_line_tab1 = 10;
  unsigned int nb_col_tab2 = 10;
  unsigned int nb_line_tab2 = 10;

  // Initiate matrix A
  int **tab = malloc(nb_line_tab1 * sizeof(int*));
  if (tab == NULL) { return 1; }
  for (unsigned int i = 0; i != nb_line_tab1; i++) {
    tab[i] = malloc(sizeof(int) * nb_col_tab1);
    if (tab[i] == NULL) {
      return 1;
    }
    for (unsigned int j = 0; j != nb_col_tab1; j++) {
      tab[i][j] = (i + 1) * (j + 1);
    }
  }

  // Initiate matrix B
  int **tab2 = malloc(nb_line_tab2 * sizeof(int*));
  if (tab2 == NULL) {
    free_matrix(tab, nb_line_tab1);
    return 1;
  }
  for (unsigned int i = 0; i != nb_line_tab2; i++) {
    tab2[i] = malloc(sizeof(int) * nb_col_tab2);
    if (tab2[i] == NULL) {
      free_matrix(tab, nb_line_tab1);
      free_matrix(tab2, i + 1);
      return 1;
    }
    for (unsigned int j = 0; j != nb_col_tab2; j++) {
      tab2[i][j] = 10;
    }
  }
  int **res = NULL;

  //Print initial matrices
  puts("RESULT BELOW CHECK WORKING CASE");
  puts("Matrix A:");
  print_matrix(tab, nb_col_tab1, nb_line_tab1);
  puts("Matrix B:");
  print_matrix(tab2, nb_col_tab2, nb_line_tab2);

  // Tests on working addition
  puts("Matrix A + Matrix A:");
  res = add_matrix(tab, tab, nb_col_tab1, nb_line_tab1);
  print_matrix(res, nb_col_tab1, nb_line_tab1);

  // Tests on working substraction
  puts("Matrix B - Matrix B:");
  res = sub_matrix(tab, tab, nb_col_tab1, nb_line_tab1);
  print_matrix(res, nb_col_tab1, nb_line_tab1);

  // Tests on working multiplication
  puts("Matrix A * Matrix B:");
  res = multiply_matrix(tab, tab2, nb_col_tab1, nb_line_tab1, nb_col_tab2, nb_line_tab2);
  print_matrix(res, nb_col_tab2, nb_line_tab1);

  // Tests with NULL values
  puts("RESULT BELOW CHECK INVALID CASE");
  puts("Matrix A + NULL:");
  res = add_matrix(tab, NULL, nb_col_tab1, nb_line_tab1);
  print_matrix(res, nb_col_tab1, nb_line_tab1);
  puts("NULL + Matrix A:");
  res = add_matrix(NULL, tab, nb_col_tab1, nb_line_tab1);
  print_matrix(res, nb_col_tab1, nb_line_tab1);
  puts("Matrix A - NULL:");
  res = sub_matrix(tab, NULL, nb_col_tab1, nb_line_tab1);
  print_matrix(res, nb_col_tab1, nb_line_tab1);
  puts("NULL - Matrix A:");
  res = sub_matrix(NULL, tab, nb_col_tab1, nb_line_tab1);
  print_matrix(res, nb_col_tab1, nb_line_tab1);

  // Tests with invalid size
  puts("Addition invalid line number:");
  res = add_matrix(tab, tab, nb_col_tab1, 0);
  print_matrix(res, nb_col_tab1, nb_line_tab1);
  puts("Addition invalid column number:");
  res = add_matrix(tab, tab, 0, nb_line_tab1);
  print_matrix(res, nb_col_tab1, nb_line_tab1);
  puts("Matrix multiplication, invalid line number matrix A");
  res = multiply_matrix(tab, tab2, nb_col_tab1, 0, nb_col_tab2, nb_line_tab2);
  print_matrix(res, nb_col_tab2, nb_line_tab1);
  puts("Matrix multiplication, non matching size");
  res = multiply_matrix(tab, tab2, nb_col_tab1, nb_line_tab1, 42, 42);
  print_matrix(res, nb_col_tab2, nb_line_tab1);

  // Free the memory
  free_matrix(tab, nb_line_tab1);
  free_matrix(tab2, nb_line_tab2);
  free_matrix(res, nb_line_tab1);
  return 0;
}
