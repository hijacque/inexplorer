from django.urls import path

from . import views

urlpatterns = [
    path('tile/<int:map_id>/<int:z>/<int:x>/<int:y>/', views.tile, name='tile'),
    path('search-bounds/', views.search_bounds, name='search-bounds'),
    path('lookup-map/', views.lookup_map, name='lookup-map'),
    path('lookup/', views.lookup, name='lookup'),
    path('search/', views.search, name='search'),
    path('routes/', views.routes, name='routes')
]