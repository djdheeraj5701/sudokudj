import 'package:flutter/material.dart';
import 'package:sudokudj/services/gVars.dart';

class mySudokuPage extends StatefulWidget {
  @override
  _mySudokuPageState createState() => _mySudokuPageState();
}

class _mySudokuPageState extends State<mySudokuPage>{
  Color dividerColor=Colors.white54;
  double size;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<List<int>> valueBox=[];

  List<List<bool>> lockBox=[];

  @override
  initState(){
    super.initState();
    setInitialValueBox();
  }

  mySnackBar(t,c){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            t,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: Colors.grey[800],
            ),
          ),
          backgroundColor: c,
          duration: Duration(seconds: 3),
        )
    );
  }

  setInitialValueBox(){
    valueBox=[
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0]
    ];
    lockBox=[
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
      [false,false,false,false,false,false,false,false,false],
    ];
  }

  changeValueBox(px,py){
    setState(() {
      valueBox[px][py]=(valueBox[px][py]+1)%10;
    });
  }

  bool columnChecker(c,i){
    if(i==0){
      return true;
    }
    for(int j in [0,1,2,3,4,5,6,7,8]){
      if(i==valueBox[j][c]){
        return false;
      }
    }
    return true;
  }

  bool rowChecker(r,i){
    if(i==0){
      return true;
    }
    for(int j in [0,1,2,3,4,5,6,7,8]){
      if(i==valueBox[r][j]){
        return false;
      }
    }
    return true;
  }

  bool blockChecker(r,c,e){
    if(e==0){
      return true;
    }
    for(int i=((r/3).toInt())*3;i<((r/3+1).toInt())*3;i++){
      for(int j=((c/3).toInt())*3;j<((c/3+1).toInt())*3;j++){
        if(e==valueBox[i][j]){
          return false;
        }
      }
    }
    return true;
  }

  sudokuValidator(){
    int x;
    for(int i in [0,1,2,3,4,5,6,7,8]){
      for(int j in [0,1,2,3,4,5,6,7,8]){
        if(valueBox[i][j]!=0){
          x=valueBox[i][j];
          valueBox[i][j]=0;
          if(
          rowChecker(i, x) &&
              columnChecker(j,x) &&
              blockChecker(i,j, x)){
            valueBox[i][j]=x;
            lockBox[i][j]=true;continue;
          }else{
            valueBox[i][j]=-1;
            return false;
          }
        }
      }
    }
    return true;
  }

  sudokuSolver(r,c){
    //await Future.delayed(Duration(milliseconds: 10));
    if(c==valueBox.length){
      r+=1;c=0;
    }
    if(r==valueBox.length){
      return true;
    }
    if(valueBox[r][c]!=0){
      //lockBox[r][c]=true;
      return sudokuSolver(r, c+1);
    }

    List<int> toChoose=[];
    for(int i in [1,2,3,4,5,6,7,8,9]){
      if(
      rowChecker(r, i) &&
          columnChecker(c, i) &&
          blockChecker(r, c, i)){
        toChoose.add(i);
      }
    }

    for(int i in toChoose){
      setState(() {
        valueBox[r][c]=i;
      });
      if(sudokuSolver(r, c+1)){
        return true;
      }
    }
    setState(() {
      valueBox[r][c]=0;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Screen.setScreenSize(context);
    size=Screen.shorter/3;
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            toolbarHeight: 100,
            title: Text(" S U D O K U "),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 75,
                ),
                Center(
                  child: Container(
                    height: Screen.shorter+10,
                    width: Screen.shorter+10,
                    child: Stack(
                      children: [
                        Container(
                          height: Screen.shorter+10,
                          width: Screen.shorter+10,
                          child: GridView.builder(
                              itemCount: 81,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
                              itemBuilder: (context,index){
                                int posx=(index/9).toInt(),posy=index%9;
                                double size2=Screen.shorter/9.2;
                                return Center(
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        changeValueBox(posx, posy);
                                      });
                                    },
                                    child: Container(
                                      height: size2,width: size2,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(color: Colors.lightBlue),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.blue[600],
                                                offset: Offset(size2/50,size2/50),
                                                blurRadius: size2/20,
                                                spreadRadius: 1.0
                                            ),
                                            BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(-size2/50,-size2/50),
                                                blurRadius: size2/20,
                                                spreadRadius: 1.0
                                            ),
                                          ],
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: lockBox[posx][posy]?
                                              [
                                                Colors.blueGrey[200],
                                                Colors.blueGrey[300],
                                                Colors.blueGrey[400],
                                                Colors.blueGrey[500],
                                              ] :
                                              [
                                                Colors.lightBlueAccent[100].withOpacity(0.7),
                                                Colors.lightBlueAccent[100],
                                                Colors.lightBlueAccent[200].withOpacity(0.7),
                                                Colors.lightBlueAccent[200],
                                              ],
                                              stops: [
                                                0.1,
                                                0.3,
                                                0.8,
                                                1
                                              ]
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          valueBox[posx][posy]!=0?
                                          valueBox[posx][posy].toString():"",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: size2/2,
                                            color: lockBox[posx][posy] ?
                                            Colors.lightBlueAccent[100]:
                                            Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: Screen.shorter,
                              width: Screen.shorter/3-2.5,
                            ),
                            Container(
                              height: Screen.shorter,
                              width: 5,
                              color: dividerColor,
                            ),
                            Container(
                              height: Screen.shorter,
                              width: Screen.shorter/3-5,
                            ),
                            Container(
                              height: Screen.shorter,
                              width: 5,
                              color: dividerColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: Screen.shorter,
                              height: Screen.shorter/3-2.5,
                            ),
                            Container(
                              width: Screen.shorter,
                              height: 5,
                              color: dividerColor,
                            ),
                            Container(
                              width: Screen.shorter,
                              height: Screen.shorter/3-5,
                            ),
                            Container(
                              width: Screen.shorter,
                              height: 5,
                              color: dividerColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setInitialValueBox();
                        setState(() {
                          print(valueBox);
                          mySnackBar("New Board Available!",Colors.greenAccent);
                        });
                      },
                      child: Container(
                        height: 75,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.lightBlue),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue[600],
                                  offset: Offset(size/50,size/50),
                                  blurRadius: size/20,
                                  spreadRadius: 1.0
                              ),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-size/50,-size/50),
                                  blurRadius: size/20,
                                  spreadRadius: 1.0
                              ),
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.lightBlueAccent[100].withOpacity(0.7),
                                  Colors.lightBlueAccent[100],
                                  Colors.lightBlueAccent[200].withOpacity(0.7),
                                  Colors.lightBlueAccent[200],
                                ],
                                stops: [
                                  0.1,
                                  0.3,
                                  0.8,
                                  1
                                ]
                            )
                        ),
                        child: Center(
                          child: Text(
                            " N E W ",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 21,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        if(sudokuValidator()){
                          sudokuSolver(0, 0);
                          setState(() {
                            mySnackBar("Solved!",Colors.lightGreenAccent);
                            print(valueBox);
                          });
                        }else{
                          setState(() {
                            mySnackBar("Error! Check board again.",Colors.redAccent);
                          });
                        }
                      },
                      child: Container(
                        height: 75,
                        width: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.lightBlue),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue[600],
                                  offset: Offset(size/50,size/50),
                                  blurRadius: size/20,
                                  spreadRadius: 1.0
                              ),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-size/50,-size/50),
                                  blurRadius: size/20,
                                  spreadRadius: 1.0
                              ),
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.lightBlueAccent[100].withOpacity(0.7),
                                  Colors.lightBlueAccent[100],
                                  Colors.lightBlueAccent[200].withOpacity(0.7),
                                  Colors.lightBlueAccent[200],
                                ],
                                stops: [
                                  0.1,
                                  0.3,
                                  0.8,
                                  1
                                ]
                            )
                        ),
                        child: Center(
                          child: Text(
                            " S O L V E !",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 21,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
