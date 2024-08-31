import 'package:cloud_firestore/cloud_firestore.dart';

class SaveArticle {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveArticle(
      String userId, Map<String, dynamic> articleData) async {
    try {
      CollectionReference savedArticlesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_articles');

      // Thêm tài liệu với một ID được tạo tự động
      await savedArticlesCollection.add(articleData);

      print('Lưu tin tức thành công');
    } catch (e) {
      print('Lỗi khi lưu tin tức: $e');
    }
  }

  Future<void> savedHistory(Map<String, dynamic> articleData) async {
    try {
      CollectionReference savedHistoryArticlesCollection =
          FirebaseFirestore.instance.collection('noUser');

      // Thêm tài liệu với một ID được tạo tự động
      await savedHistoryArticlesCollection.add(articleData);

      print('Lưu tin tức vào lịch sử thành công');
    } catch (e) {
      print('Lỗi khi lưu tin tức vào lịch sử: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHistorySavedArticles() async {
    final QuerySnapshot querySnapshot =
        await _firestore.collection('noUser').get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> removeAllHistorySavedArticles() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('noUser').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }

      print('Đã xoá tất cả lịch sử tin tức');
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  // -------------------------- SHOW LIST TẤT CẢ TIN TỨC ĐÃ LƯU----------------------------------
  Future<List<Map<String, dynamic>>> getSavedArticles(String userId) async {
    final DocumentReference userDocRef =
        _firestore.collection('users').doc(userId);

    final QuerySnapshot querySnapshot =
        await userDocRef.collection('saved_articles').get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

// -------------------------- XOÁ TẤT CẢ TIN TỨC ----------------------------------
  Future<void> removeAllSavedArticles(String userId) async {
    try {
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(userId);

      final CollectionReference savedArticlesRef =
          userDocRef.collection('saved_articles');

      QuerySnapshot querySnapshot = await savedArticlesRef.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }

      print('Đã xoá tất cả tin tức đã lưu');
    } catch (e) {
      print('Lỗi: $e');
    }
  }
}
