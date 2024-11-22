
//高德appkey    e0a79a5cdda10fc1dfd50ff59834f9f6

// MAP_TYPE_NORMAL：1
// 普通地图模式
// MAP_TYPE_SATELLITE：2
// 卫星图模式
// MAP_TYPE_NIGHT：3
// 夜景图模式
// MAP_TYPE_NAVI：4
// 导航模式
// MAP_TYPE_BUS: 5
// 公交模式
// MAP_TYPE_NAVI_NIGHT: 6
// 导航夜间模式

import {
  AMap,
  MapsInitializer,
  MapView,
  MapViewComponent,
  MapViewManager,
  MapType,
  CameraUpdateFactory,
  LatLng,
  MarkerOptions
} from '@amap/amap_lbs_map3d';

import { promptAction } from '@kit.ArkUI';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { geoLocationManager } from '@kit.LocationKit';
import { CommonConstants } from '../common/CommonConstants';



interface LocationInter {
  latitude: number,
  longitude: number
};

@Entry
@Component
struct GdMapView {

  @State address: string = '';
  private mapController?: map.MapComponentController;
  private callback?: AsyncCallback<map.MapComponentController>;
  private marker?: map.Marker;
  private mapOption?: mapCommon.MapOptions;

  //高德
  private mapView? : MapView;
  private vMap? : AMap;

  getLocationPosition(): void {
    let request: geoLocationManager.SingleLocationRequest = {
      locatingPriority: CommonConstants.PRIORITY_LOCATING_SPEED,
      locatingTimeoutMs: CommonConstants.TEN_THOUSAND
    };
    geoLocationManager.getCurrentLocation(request).then((location: geoLocationManager.Location) => {
      console.log('current location: ' + location.latitude+location.longitude);
    }).catch((err: BusinessError) => {
      promptAction.showToast({
        message: JSON.stringify(err),
        duration: CommonConstants.TWO_THOUSAND
      });
    });
  }

  aboutToAppear(): void {
    MapsInitializer.setApiKey("e0a79a5cdda10fc1dfd50ff59834f9f6");
    MapViewManager.getInstance().registerMapViewCreatedCallback((mapview?: MapView, mapViewName?: string) => {
      if (!mapview) {
        return;
      }
      let mapView = mapview;
      mapView.onCreate();
      mapView.getMapAsync((map) => {
        // map.setMapType(MapType.MAP_TYPE_SATELLITE)  //设置地图类型为卫星图
        let aMap: AMap = map;
        this.vMap = aMap;

        let latlngPoint = new LatLng(39.144105279768, 117.15651537432);

        aMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(39.144105279768, 117.15651537432), 16));

        let options: MarkerOptions = new MarkerOptions();
        options.setPosition(latlngPoint);
        let marker = aMap.addMarker(options);
      })
    })

  }


  build() {

    Column(){
      Row() {
        MapViewComponent()
          .height(CommonConstants.EIGHTY_FIVE_PERCENT)
          .width(CommonConstants.ONE_HUNDRED_PERCENT)
      }


      // Button('获取经纬度')
      //   .onClick(() => {
      //     this.getLocationPosition();
      //   })

      Button('zoom')
        .onClick(() => {

          this.vMap?.moveCamera(CameraUpdateFactory.zoomTo(12))

        })

    }


  }
}