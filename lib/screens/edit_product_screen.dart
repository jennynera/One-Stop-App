import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shop/providers/products.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class EditProductScreen  extends StatefulWidget {
  static const routeName ='/edit_product';


  @override
  _State createState() => _State();
}

class _State extends State<EditProductScreen> {
    final _pricefocusnode = FocusNode();
    final _descfocusnode = FocusNode();
    final _imgUrlController = TextEditingController();
    final _imgUrlFocusNode = FocusNode();
    final _form =GlobalKey<FormState>();
   
   
    var _editedProduct = Product(
       id:null,
      title:'',
      price:0,
      description:'',
      imageUrl:'',
    );

var _initValues ={

      'title':'',
      'price':'',
   'description':'',
      'imageUrl':'',

};
  var _isInit =true;
  var _isLoading= false;


 @override
   void initState() {
   _imgUrlFocusNode.addListener(_updateImgUrl);
 
     super.initState();
   }

   @override
     void didChangeDependencies() {
      if(_isInit){
       final productId = ModalRoute.of(context).settings.arguments as String;
       if(productId !=null){
      _editedProduct = Provider.of<Products>(context,listen: false).findById(productId);
       _initValues = {
         'title':_editedProduct.title,
         'description':_editedProduct.description,
         'price':_editedProduct.price.toString(),
         //'imgUrl':_editedProduct.imageUrl
         'imgUrl':'',
       };
       _imgUrlController.text = _editedProduct.imageUrl;

       }

      }
       _isInit = false;
       super.didChangeDependencies();
     }

@override
  void dispose() {
_imgUrlFocusNode.removeListener(_updateImgUrl);
 _pricefocusnode.dispose();
 _descfocusnode.dispose();
 _imgUrlController.dispose();
 _imgUrlFocusNode.dispose();
 
    super.dispose();
  }
 
 void _updateImgUrl(){
  if (!_imgUrlFocusNode.hasFocus){
       if ((!_imgUrlController.text.startsWith('http') &&
              !_imgUrlController.text.startsWith('https')) 
              //||
          // (!_imgUrlController.text.endsWith('.png') &&
          //     !_imgUrlController.text.endsWith('.jpg') &&
          //     !_imgUrlController.text.endsWith('.jpeg'))
   )
          { return ;   
              }
            
    
    
    
    
    setState(() {  });
  }
 }

Future <void> _saveform() async {
final isValid =_form.currentState.validate();
if(!isValid){
  return;
}

 _form.currentState.save();
 setState(() {
    
 _isLoading=true;
  });

 if(_editedProduct.id!=null){
await Provider.of<Products>(context,listen: false)
.updateProduct(_editedProduct. id, _editedProduct);
 
 }
 else{
   try{

  await Provider.of<Products>(context,listen: false)
 .addProduct(_editedProduct);}

 catch(error){
 await showDialog(
  context: context, 
  builder:(ctx)=>AlertDialog(
    title: Text('An error occured'),
    content:Text('Something went wrong'),
    actions: [
      TextButton(child:Text('Okay'),
                 onPressed: (){
                  Navigator.of(ctx).pop(); 
                 },
                 )
    ],
 )
);
 }
// finally {
//   setState(() {
    
//  _isLoading=false;
//   });
   
//  Navigator.of(context).pop();
// }

 }

 setState(() {
    
 _isLoading=false;
  });
 
 Navigator.of(context).pop();
 
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product'),
      actions: [
       IconButton(
         icon: Icon(Icons.save),
        onPressed:_saveform)
      ],
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child:ListView(
          children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: InputDecoration(
              labelText: 'Title'),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_pricefocusnode);
            },
            validator:(value){
              if(value.isEmpty){
                return 'Please enter a value';
              }
               return null;
            } ,

            
            onSaved: (value){
              _editedProduct= Product(
 
                title: value, 
                description: _editedProduct.description, 
                price: _editedProduct.price,
                 imageUrl: _editedProduct.imageUrl,
                 id: _editedProduct.id,
                 isFavorite: _editedProduct.isFavorite,
                );
            },


            ),
             TextFormField(
                 initialValue: _initValues['price'],
              decoration: InputDecoration(
              labelText: 'Price'),
            textInputAction: TextInputAction.next,
            keyboardType:TextInputType.number,
            focusNode: _pricefocusnode ,
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_descfocusnode);
            },
             validator:(value){
              if(value.isEmpty){
                return 'Please enter a price';
              }
              if(double.tryParse(value)== null){
                return'Please enter a valid number';
              }
              if(double.tryParse(value)<=0){
                return 'Please enter a number greater than zero';
              }
               return null;
            } ,
            onSaved: (value){
              _editedProduct= Product(
                
                title: _editedProduct.title, 
                description: _editedProduct.description, 
                price: double.parse(value),
                 imageUrl: _editedProduct.imageUrl,
                  id: _editedProduct.id,
                 isFavorite: _editedProduct.isFavorite,);
            },
            ),
            TextFormField(
                initialValue: _initValues['description'],
              decoration: InputDecoration(
              labelText: 'Description'),
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              focusNode: _descfocusnode,

              onSaved: (value){
              _editedProduct= Product(
                
                title: _editedProduct.title, 
                description:value, 
                price: _editedProduct.price,
                 imageUrl: _editedProduct.imageUrl,
                  id: _editedProduct.id,
                 isFavorite: _editedProduct.isFavorite,);
            },
             validator:(value){
              if(value.isEmpty){
                return 'Please enter a description';
              }
              if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
               return null;
            } ,
            ),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 8,right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey
                    )
                    ),
                    child:_imgUrlController.text.isEmpty ?
                     Text('Enter a URL') :
                    FittedBox(
                      child: Image.network(
                        _imgUrlController.text,
                        fit: BoxFit.cover,
                      ),),
              ),
              Expanded(
                child: TextFormField(
                   // initialValue: _initValues['imgUrl'],
                  decoration:InputDecoration(labelText:'Image URL') ,
                  keyboardType: TextInputType.url,
                  textInputAction:TextInputAction.done,
                  controller: _imgUrlController,
                  focusNode: _imgUrlFocusNode,
                  onFieldSubmitted:(_){
                    _saveform();
                  } ,
                  validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        // if (!value.endsWith('.png') &&
                        //     !value.endsWith('.jpg') &&
                        //     !value.endsWith('.jpeg')) {
                        //   return 'Please enter a valid image URL.';
                        // }
                        return null;
                      },
                  
                  onSaved: (value){
              _editedProduct= Product(
                
                title: _editedProduct.title, 
                description:_editedProduct.description, 
                price: _editedProduct.price,
                 imageUrl: value,
                  id: _editedProduct.id,
                 isFavorite: _editedProduct.isFavorite,);
            },

                  
                  ),
              )
            ],)




          ],
        )
        
        ),
      ),
    );
  }
}

