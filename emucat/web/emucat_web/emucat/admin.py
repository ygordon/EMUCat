from django.contrib import admin

from .models import Mosaics, Components, SourceExtractionRegion, \
    SchedulingBlocks, MosaicPrerequisites, AllWise, Sources


class AllWiseAdmin(admin.ModelAdmin):
    model = AllWise
    list_display = ('designation', 'ra_dec')

    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        if request.user.is_superuser:
            return True
        return False

    def has_change_permission(self, request, obj=None):
        return False


class MosaicPrerequisitesAdminInline(admin.TabularInline):
    model = MosaicPrerequisites


class SourceExtractionRegionAdmin(admin.ModelAdmin):
    model = SourceExtractionRegion
    inlines = [MosaicPrerequisitesAdminInline, ]


class SchedulingBlocksAdmin(admin.ModelAdmin):
    model = SchedulingBlocks


class MosaicAdmin(admin.ModelAdmin):
    model = Mosaics
    list_display = ('ser', 'subsection')

    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def has_change_permission(self, request, obj=None):
        return False


class ComponentsAdmin(admin.ModelAdmin):
    model = Components
    list_display = ('component_name', 'mosaic_id', 'ra_deg_cont', 'dec_deg_cont')

    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def has_change_permission(self, request, obj=None):
        return False


class SourcesAdmin(admin.ModelAdmin):
    model = Sources
    list_display = ('id', 'component_id', 'wise_id', 'separation')

    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def has_change_permission(self, request, obj=None):
        return False


admin.site.register(AllWise, AllWiseAdmin)
admin.site.register(SourceExtractionRegion, SourceExtractionRegionAdmin)
admin.site.register(SchedulingBlocks, SchedulingBlocksAdmin)
admin.site.register(Mosaics, MosaicAdmin)
admin.site.register(Components, ComponentsAdmin)
admin.site.register(Sources, SourcesAdmin)