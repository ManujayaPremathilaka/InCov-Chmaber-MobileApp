
class UserModel{

  /** These variables hold user inputs **/
  String emp_id = '';
  String full_name = '';
  String organization ='';
  String position = '';
  String user_name = '';
  String password = '';
  String base64Image;

 save() async {
   print('Full Name : $full_name');
   print('Organization: $organization');
   print('$base64Image');
 }


}