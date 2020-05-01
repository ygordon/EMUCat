from django.db import models


class Mosaics(models.Model):
    id = models.BigAutoField(primary_key=True)
    table_version = models.TextField(blank=True, null=True)
    image_file = models.TextField(blank=True, null=True)
    flag_subsection = models.BooleanField()
    subsection = models.TextField(blank=True, null=True)
    flag_statsec = models.BooleanField()
    statsec = models.TextField(blank=True, null=True)
    search_type = models.TextField(blank=True, null=True)
    flag_negative = models.BooleanField()
    flag_baseline = models.BooleanField()
    flag_robuststats = models.BooleanField()
    flag_fdr = models.BooleanField()
    threshold = models.FloatField()
    flag_growth = models.BooleanField()
    growth_threshold = models.FloatField()
    min_pix = models.IntegerField(blank=True, null=True)
    min_channels = models.IntegerField(blank=True, null=True)
    min_voxels = models.IntegerField(blank=True, null=True)
    flag_adjacent = models.BooleanField()
    thresh_velocity = models.FloatField()
    flag_rejectbeforemerge = models.BooleanField()
    flag_twostagemerging = models.BooleanField()
    pixel_centre = models.TextField(blank=True, null=True)
    flag_smooth = models.BooleanField()
    flag_atrous = models.BooleanField()
    reference_frequency = models.FloatField()
    threshold_actual = models.FloatField()

    def __str__(self):
        return self.image_file

    class Meta:
        managed = False
        db_table = 'mosaics'
        verbose_name_plural = 'Mosaics'
        ordering = ("image_file", "subsection",)


class Sources(models.Model):
    id = models.BigAutoField(primary_key=True)
    mosaic = models.ForeignKey(Mosaics, models.DO_NOTHING)
    island_id = models.TextField(blank=True, null=True)
    component_id = models.TextField(blank=True, null=True)
    component_name = models.TextField(blank=True, null=True)
    ra_hms_cont = models.TextField(blank=True, null=True)
    dec_hms_cont = models.TextField(blank=True, null=True)
    ra_deg_cont = models.DecimalField(max_digits=65535, decimal_places=6, blank=True, null=True)
    dec_deg_cont = models.DecimalField(max_digits=65535, decimal_places=6, blank=True, null=True)
    ra_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    dec_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    freq = models.DecimalField(max_digits=65535, decimal_places=1, blank=True, null=True)
    flux_peak = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    flux_peak_err = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    flux_int = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    flux_int_err = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    maj_axis = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    min_axis = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    pos_ang = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    maj_axis_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    min_axis_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    pos_ang_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    maj_axis_deconv = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    min_axis_deconv = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    pos_ang_deconv = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    maj_axis_deconv_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    min_axis_deconv_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    pos_ang_deconv_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    chi_squared_fit = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    rms_fit_gauss = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    spectral_index = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    spectral_curvature = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    spectral_index_err = models.DecimalField(max_digits=65535, decimal_places=2, blank=True, null=True)
    spectral_curvature_err = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    rms_image = models.DecimalField(max_digits=65535, decimal_places=3, blank=True, null=True)
    has_siblings = models.IntegerField()
    fit_is_estimate = models.IntegerField()
    spectral_index_from_tt = models.IntegerField()
    flag_c4 = models.IntegerField()
    comment = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.component_name

    class Meta:
        managed = False
        db_table = 'sources'
        verbose_name_plural = 'Sources'
        ordering = ("component_name", "ra_deg_cont", "dec_deg_cont")
