import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  // define o foco do formulário
  final _descFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();

  final _imageController = TextEditingController();

  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(upgradeImageUrl);
  }

  void upgradeImageUrl() {
    // SÓ ALTERA O ESTADO MEDIANTE UMA IMAGEM VÁLIDA
    if (isValidImageUrl(_imageController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startsWithHttp = url.toLowerCase().startsWith('http://');
    bool startsWithHttps = url.toLowerCase().startsWith('https://');

    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startsWithHttp || startsWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  //
  @override
  void dispose() {
    super.dispose();
    _descFocusNode.dispose();
    _priceFocusNode.dispose();

    _imageFocusNode.removeListener(upgradeImageUrl);
    _imageFocusNode.dispose();
  }

  void _saveForm() {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    // só roda se passar pela validação acima
    _form.currentState.save();

    final newProduct = Product(
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['desc'],
      imageUrl: _formData['imgUrl'],
    );

    // listen false para evittar o problema do provider fora da widget tree
    Provider.of<Products>(context, listen: false).addProduct(newProduct);
    Navigator.of(context).pop();
    // print(newProduct.id);
    // print(newProduct.title);
    // print(newProduct.price);
    // print(newProduct.description);
    // print(newProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              // PREVIEW DA IMAGEM
              Container(
                  height: 200,
                  width: 100,
                  margin:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: _imageController.text.isEmpty
                      ? Center(
                          child: Text(
                            "Image preview",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        )
                      : FittedBox(
                          child: Image.network(
                            _imageController.text,
                            fit: BoxFit.fill,
                          ),
                        )),

              // TITULO
              TextFormField(
                decoration: InputDecoration(labelText: 'Titulo'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 4;

                  if (isEmpty || isInvalid) {
                    return 'Informe um título válido com no mínimo 4 caracteres!';
                  }

                  return null;
                },
              ),

              // PREÇO
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value),
                validator: (value) {
                  var newPrice = double.tryParse(value);

                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = newPrice == null || newPrice <=0;

                  if (isEmpty || isInvalid) {
                    return 'Informe uma preço válido!';
                  }

                  return null;
                },
              ),

              // DESCRICAO
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                focusNode: _descFocusNode,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (value) => _formData['desc'] = value,
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 10;

                  if (isEmpty || isInvalid) {
                    return 'Informe uma descrição válida com no mínimo 10 caracteres!';
                  }

                  return null;
                },
              ),

              // IMAGEM
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url da imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageFocusNode,
                      controller: _imageController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) => _formData['imgUrl'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = !isValidImageUrl(value);

                        if (isEmpty || isInvalid) {
                          return 'Informe uma URL válida!';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
