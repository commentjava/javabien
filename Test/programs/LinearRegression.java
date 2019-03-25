class LinearRegression{
  static void main(){
    double a = 0, b = 0, coef = 0.1, coef_modif = 0.8;
    int dist = 4, nb_p = 10, nb_tot = dist * nb_p, nb_epoch = 100;
    double[] x = new double[dist * nb_p];
    double[] y = new double[dist * nb_p];
    
    // build the training set
    // the points are following the function f : x |-> { n     if x in [2n; 2n+1[   for all n in N
    //                                                 { x - n if x in [2n+1; 2n+2[
    // so we expect a linear regretion that gives a~=0.5 and b~=-0.25

    for(int i = 0 ; i < dist ; i ++){
      for(int j = 0 ; j < nb_p ; j ++){
        x[i * nb_p + j] = i + (1.0 * j / nb_p);
        double y_val = i / 2;
        if(i % 2 == 1){
          y_val += 1.0 * j / nb_p;
        }
        y[i * nb_p + j] = y_val;
      }
    }

    // learning

    for(int e = 0 ; e < nb_epoch ; e ++){
      for(int i = 0 ; i < nb_tot ; i ++){
        a -= ((-2)*y[i]*x[i] + 2*a*x[i]*x[i] + 2*b*x[i]) * coef;
        b -= ((-2)*y[i] + 2*a*x[i] + 2*b) * coef;
      }
      coef *= coef_modif;
    }
    Debug.debug(a);
    Debug.debug(b);
  }
}
