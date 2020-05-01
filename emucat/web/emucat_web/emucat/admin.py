from django.contrib import admin

from .models import Mosaics, Sources


class MosaicAdmin(admin.ModelAdmin):
    model = Mosaics
    list_display = ('image_file', 'subsection')

    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def has_change_permission(self, request, obj=None):
        return False


class SourceAdmin(admin.ModelAdmin):
    model = Sources
    list_display = ('component_name', 'ra_deg_cont', 'dec_deg_cont')

    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def has_change_permission(self, request, obj=None):
        return False


admin.site.register(Mosaics, MosaicAdmin)
admin.site.register(Sources, SourceAdmin)