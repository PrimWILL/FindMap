import 'package:findmap/src/digit.dart';
import 'package:findmap/src/my_colors.dart';
import 'package:findmap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  static const int MAX_Y = 19;
  static const int MAX_X = 5;
  static const int MAX_RADIO = 30;
  static const int MIN_RADIO = 10;

  late TextEditingController _searchKeyword;
  bool _visibleSearchInput = false;
  late List<ChartData> chartData;

  @override
  void initState() {
    var colorList = CHART_COLOR.toList()..shuffle();
    chartData = [
      ChartData('추천단어1', 1, 4, 3, colorList[0]),
      ChartData('추천단어2', 2, 16, 5, colorList[1]),
      ChartData('검색어', 3, 10, 30, colorList[2]),
      ChartData('추천단어4', 4, 14, 12, colorList[3]),
      ChartData('추천단어5', 5, 8, 15, colorList[4]),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _searchKeyword = TextEditingController(text: '');
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: AnimatedOpacity(
              opacity: _visibleSearchInput ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: TextFormField(
                controller: _searchKeyword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: "검색어를 입력하세요",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                    minimum: 0, maximum: MAX_X + 1, isVisible: false),
                primaryYAxis: NumericAxis(
                    minimum: 0, maximum: MAX_Y + 1, isVisible: false),
                plotAreaBorderColor: Colors.transparent,
                series: <ChartSeries>[
                  BubbleSeries<ChartData, double>(
                      maximumRadius: MAX_RADIO,
                      minimumRadius: MIN_RADIO,
                      dataSource: chartData,
                      sizeValueMapper: (ChartData sales, _) => sales.size,
                      xValueMapper: (ChartData sales, _) => sales.x,
                      yValueMapper: (ChartData sales, _) => sales.y,
                      pointColorMapper: (ChartData sales, _) => sales.color,
                      dataLabelMapper: (ChartData sales, _) => sales.name,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.middle,
                      ),
                      onPointTap: (ChartPointDetails details) {
                        _tap(details.pointIndex);
                      },
                      onPointLongPress: (ChartPointDetails details) {
                        _longTap(details.pointIndex);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _visibleSearchInput = !_visibleSearchInput;
          });
        },
        child: const Icon(Icons.search),
        backgroundColor: MyColors.search,
      ),
    );
  }

  void _longTap(int? index) {
    print(index);
    String _searchKeyWord = '검색어가 존재하지 않습니다';
    if (index != null) {
      _searchKeyWord = chartData[index].name;
    }
    Navigator.push(context, createRoute(_webView(_searchKeyWord)));
  }

  void _tap(int? index) {
    setState(() {
      var colorList = CHART_COLOR.toList()..shuffle();
      var xList = POSITION_X.toList()..shuffle();
      var yList = POSITION_Y.toList()..shuffle();
      var size = SIZE.toList()..shuffle();
      chartData = [
        ChartData('추천단어10', xList[0], yList[0], size[0], colorList[0]),
        ChartData('추천단어20', xList[1], yList[1], size[1], colorList[1]),
        ChartData('새로운 검색어', 3, 10, 30, colorList[2]),
        ChartData('추천단어40', xList[3], yList[3], size[2], colorList[3]),
        ChartData('추천단어50', xList[4], yList[4], size[3], colorList[4]),
      ];
    });
  }

  Widget _webView(String search) {
    return SafeArea(
      child: WebView(
        initialUrl:
            'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query=$search',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class ChartData {
  final String name;
  final double x;
  final double y;
  final double size;
  final Color color;

  ChartData(this.name, this.x, this.y, this.size, this.color);
}
