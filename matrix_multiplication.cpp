#include<iostream>
using namespace std;
int main(){
    int a,b,c,d;
    cout<<"Enter a and b  ";
    cin>>a>>b;
    
    cout<<"Enter c and d  ";
    cin>>c>>d;
    /*if(b!=c){
        cout<<"Operation can't be performed,Re enter the correct values of a and b\n";
         cout<<"Enter a and b  ";
         cin>>a>>b;
    
         cout<<"Enter c and d  ";
         cin>>c>>d;
    }*/
    int arr[a][b];
    int arr2[c][d];
    int arr3[a][d];
    for(int i=0;i<a;i++){
        for(int j=0;j<b;j++){
            cout<<"Enter element array"<<"["<<i<<"]"<<"["<<j<<"]    ";
            cin>>arr[i][j];
        }
    }
    for(int i=0;i<a;i++){
        for(int j=0;j<b;j++){
             cout<<"Enter element array2"<<"["<<i<<"]"<<"["<<j<<"]    ";
            cin>>arr2[i][j];
        }
    }
    int sum=0;
    
    if(b==c){
        for(int i=0;i<a;i++){
            for(int j=0;j<d;j++){
                for(int k=0;k<b;k++){
                sum=sum+arr[i][k]*arr2[k][j ];
                arr3[i][j]=sum;
            }sum=0;
                
            }
        }
    }
    for(int i=0;i<a;i++){
        for(int j=0;j<d;j++){
        cout<<arr3[i][j]<<"\t";
    }cout<<"\n";}
    return 0;
}
