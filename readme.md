# ทดสอบ MYSQL Performance โดยใช้ Shell Script #

## วิธีใช้

สร้าง mysql database ทดสอบชื่อ solar

* เป็นข้อมูลทดสอบจากการทำงานเก่าของผมที่ไซต์โรงงาน Solar Cell ให้บริษัทแห่งหนึ่ง

สร้าง Folder เปล่าๆ ก่อน

```bash
mkdir result
```
ลองดูว่า mysql ใช้คำสั่งได้หรือไม่

```bash
mysql --version
```

ถ้า Database พร้อมแล้ว คำสั่ง mysql ใช้ได้แล้วก็ลองกันเลย

```bash
./mainquery_index_1.sh > result/mainquery_index_1.txt
./mainquery_join_2.sh > result/mainquery_join_2.txt
./mainquery_use_two_table_vs_join_3.sh > result/mainquery_use_two_table_vs_join_3.txt
```

ดูผลลัพธ์ที่ folder ชื่อ result